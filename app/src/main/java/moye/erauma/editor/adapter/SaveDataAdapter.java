package moye.erauma.editor.adapter;

import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.FrameLayout;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import com.google.android.material.card.MaterialCardView;
import com.google.android.material.checkbox.MaterialCheckBox;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import java.util.List;

import moye.erauma.editor.EraUmaEditor;
import moye.erauma.editor.R;
import moye.erauma.editor.helper.JsonHelper;
import moye.erauma.editor.model.EditorItem;

public class SaveDataAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {
    private static final int VIEW_TYPE_IGNORE = 0;
    private static final int VIEW_TYPE_EDIT_TEXT = 1;
    private static final int VIEW_TYPE_CHECKBOX = 2;
    private static final int VIEW_TYPE_SPINNER = 3;
    private static final int VIEW_TYPE_EDIT_TEXT_DOUBLE = 4;
    private static final int VIEW_TYPE_CHECKBOX_DOUBLE = 5;
    private static final int VIEW_TYPE_SPINNER_DOUBLE = 6;
    private static final int VIEW_TYPE_HEADER = 7;


    private final List<EditorItem> items;

    public SaveDataAdapter(List<EditorItem> items) {
        this.items = items;
    }

    public void refreshAllItems() {
        if (getItemCount() > 0) {
            notifyItemRangeChanged(0, getItemCount());
        }
    }

    private String resolveJsonPath(String path) {
        return path.replace("{id}", String.valueOf(EraUmaEditor.current_character_id));
    }

    @Override
    public int getItemViewType(int position) {
        EditorItem currentItem = items.get(position);

        if (currentItem.dataType == EditorItem.DataType.HEADER) {
            return VIEW_TYPE_HEADER;
        }

        if (currentItem.layoutType == EditorItem.LayoutType.DOUBLE && position > 0) {
            int prevItemViewType = getItemViewType(position - 1);
            if (prevItemViewType == VIEW_TYPE_EDIT_TEXT_DOUBLE ||
                    prevItemViewType == VIEW_TYPE_CHECKBOX_DOUBLE ||
                    prevItemViewType == VIEW_TYPE_SPINNER_DOUBLE) {
                return VIEW_TYPE_IGNORE;
            }
        }

        switch (currentItem.dataType) {
            case BOOLEAN:
                return currentItem.layoutType == EditorItem.LayoutType.DOUBLE ? VIEW_TYPE_CHECKBOX_DOUBLE : VIEW_TYPE_CHECKBOX;
            case CHOICE:
                return currentItem.layoutType == EditorItem.LayoutType.DOUBLE ? VIEW_TYPE_SPINNER_DOUBLE : VIEW_TYPE_SPINNER;
            case INT:
            case FLOAT:
            case STRING:
            default:
                return currentItem.layoutType == EditorItem.LayoutType.DOUBLE ? VIEW_TYPE_EDIT_TEXT_DOUBLE : VIEW_TYPE_EDIT_TEXT;
        }
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        LayoutInflater inflater = LayoutInflater.from(parent.getContext());
        switch (viewType) {
            case VIEW_TYPE_HEADER:
                return new HeaderViewHolder(inflater.inflate(R.layout.item_editor_header, parent, false));
            case VIEW_TYPE_CHECKBOX:
                return new CheckboxViewHolder(inflater.inflate(R.layout.item_editor_checkbox, parent, false));
            case VIEW_TYPE_SPINNER:
                return new SpinnerViewHolder(inflater.inflate(R.layout.item_editor_spinner, parent, false));
            case VIEW_TYPE_EDIT_TEXT_DOUBLE:
                return new DoubleEditTextHolder(inflater.inflate(R.layout.item_editor_edittext_double, parent, false));
            case VIEW_TYPE_CHECKBOX_DOUBLE:
                return new DoubleCheckboxViewHolder(inflater.inflate(R.layout.item_editor_checkbox_double, parent, false));
            case VIEW_TYPE_SPINNER_DOUBLE:
                return new DoubleSpinnerViewHolder(inflater.inflate(R.layout.item_editor_spinner_double, parent, false));
            case VIEW_TYPE_IGNORE:
                View view = new FrameLayout(parent.getContext());
                view.setLayoutParams(new ViewGroup.LayoutParams(0, 0));
                return new IgnoreViewHolder(view);
            case VIEW_TYPE_EDIT_TEXT:
            default:
                return new EditTextHolder(inflater.inflate(R.layout.item_editor_edittext, parent, false));
        }
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        int viewType = holder.getItemViewType();
        EditorItem item1 = items.get(position);

        switch (viewType) {
            case VIEW_TYPE_HEADER:
            case VIEW_TYPE_EDIT_TEXT:
            case VIEW_TYPE_CHECKBOX:
            case VIEW_TYPE_SPINNER:
                ((SingleViewHolder) holder).bind(item1);
                break;

            case VIEW_TYPE_EDIT_TEXT_DOUBLE:
            case VIEW_TYPE_CHECKBOX_DOUBLE:
            case VIEW_TYPE_SPINNER_DOUBLE:
                EditorItem item2 = null;
                if (position + 1 < items.size() && getItemViewType(position + 1) == VIEW_TYPE_IGNORE) {
                    item2 = items.get(position + 1);
                }
                ((DoubleViewHolder) holder).bind(item1, item2);
                break;

            case VIEW_TYPE_IGNORE:
            default:
                break;
        }
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    interface SingleViewHolder { void bind(EditorItem item); }
    interface DoubleViewHolder { void bind(EditorItem item1, EditorItem item2); }

    static class IgnoreViewHolder extends RecyclerView.ViewHolder {
        IgnoreViewHolder(@NonNull View itemView) { super(itemView); }
    }

    class HeaderViewHolder extends RecyclerView.ViewHolder implements SingleViewHolder {
        private final TextView headerTextView;

        HeaderViewHolder(@NonNull View itemView) {
            super(itemView);
            headerTextView = (TextView) itemView;
        }

        public void bind(EditorItem item) {
            headerTextView.setText(item.label);
        }
    }

    class EditTextHolder extends RecyclerView.ViewHolder implements SingleViewHolder {
        private final TextView descriptionTextView;
        private final TextInputLayout valueInputLayout;
        private final TextInputEditText valueEditText;
        private final CustomTextWatcher textWatcher;

        EditTextHolder(@NonNull View itemView) {
            super(itemView);
            descriptionTextView = itemView.findViewById(R.id.descriptionTextView);
            valueInputLayout = itemView.findViewById(R.id.valueInputLayout);
            valueEditText = itemView.findViewById(R.id.valueEditText);
            textWatcher = new CustomTextWatcher();
            valueEditText.addTextChangedListener(textWatcher);
        }

        public void bind(EditorItem item) {
            String path = resolveJsonPath(item.jsonPath);
            textWatcher.update(item, path);
            valueInputLayout.setHint(item.label);
            boolean isDataAvailable = EraUmaEditor.save_data != null;
            valueEditText.setEnabled(isDataAvailable);
            valueInputLayout.setEnabled(isDataAvailable);
            descriptionTextView.setVisibility(item.description != null && !item.description.isEmpty() ? View.VISIBLE : View.GONE);
            descriptionTextView.setText(item.description);
            valueInputLayout.setPrefixText(item.prefix);
            valueInputLayout.setSuffixText(item.suffix);
            switch (item.dataType) {
                case INT:
                    valueEditText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_SIGNED);
                    valueEditText.setText(String.valueOf(JsonHelper.get(EraUmaEditor.save_data, path, 0)));
                    break;
                case FLOAT:
                    valueEditText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL | InputType.TYPE_NUMBER_FLAG_SIGNED);
                    valueEditText.setText(String.valueOf(JsonHelper.get(EraUmaEditor.save_data, path, 0.0f)));
                    break;
                case STRING:
                    valueEditText.setInputType(InputType.TYPE_CLASS_TEXT);
                    valueEditText.setText(JsonHelper.get(EraUmaEditor.save_data, path, ""));
                    break;
            }
        }
    }

    class CheckboxViewHolder extends RecyclerView.ViewHolder implements SingleViewHolder {
        private final TextView labelTextView, descriptionTextView;
        private final MaterialCheckBox valueCheckBox;

        CheckboxViewHolder(@NonNull View itemView) {
            super(itemView);
            labelTextView = itemView.findViewById(R.id.labelTextView);
            descriptionTextView = itemView.findViewById(R.id.descriptionTextView);
            valueCheckBox = itemView.findViewById(R.id.valueCheckBox);
        }

        public void bind(EditorItem item) {
            String path = resolveJsonPath(item.jsonPath);
            labelTextView.setText(item.label);
            boolean isDataAvailable = EraUmaEditor.save_data != null;
            valueCheckBox.setEnabled(isDataAvailable);
            descriptionTextView.setVisibility(item.description != null && !item.description.isEmpty() ? View.VISIBLE : View.GONE);
            descriptionTextView.setText(item.description);
            valueCheckBox.setOnCheckedChangeListener(null);
            boolean isChecked = false;
            if (isDataAvailable) {
                Object value = JsonHelper.get(EraUmaEditor.save_data, path, item.booleanRepresentation == EditorItem.BooleanRepresentation.AS_BOOLEAN ? false : 0);
                isChecked = value instanceof Boolean ? (Boolean) value : value instanceof Number && ((Number) value).intValue() == 1;
            }
            valueCheckBox.setChecked(isChecked);
            valueCheckBox.setOnCheckedChangeListener((buttonView, b) -> {
                Object valueToPut = b;
                if (item.booleanRepresentation == EditorItem.BooleanRepresentation.AS_INT) {
                    valueToPut = b ? 1 : 0;
                }
                JsonHelper.put(EraUmaEditor.save_data, path, valueToPut);
            });
        }
    }

    class SpinnerViewHolder extends RecyclerView.ViewHolder implements SingleViewHolder {
        private final TextView descriptionTextView;
        private final TextInputLayout valueInputLayout;
        private final AutoCompleteTextView valueSpinner;

        SpinnerViewHolder(@NonNull View itemView) {
            super(itemView);
            descriptionTextView = itemView.findViewById(R.id.descriptionTextView);
            valueInputLayout = itemView.findViewById(R.id.valueInputLayout);
            valueSpinner = itemView.findViewById(R.id.valueSpinner);
        }

        public void bind(EditorItem item) {
            String path = resolveJsonPath(item.jsonPath);
            valueInputLayout.setHint(item.label);
            boolean isDataAvailable = EraUmaEditor.save_data != null;
            valueSpinner.setEnabled(isDataAvailable);
            valueInputLayout.setEnabled(isDataAvailable);
            descriptionTextView.setVisibility(item.description != null && !item.description.isEmpty() ? View.VISIBLE : View.GONE);
            descriptionTextView.setText(item.description);
            ArrayAdapter<EditorItem.Choice> adapter = new ArrayAdapter<>(itemView.getContext(), android.R.layout.simple_spinner_dropdown_item, item.choices);
            valueSpinner.setAdapter(adapter);
            valueSpinner.setOnItemClickListener(null);
            if (isDataAvailable) {
                Object currentValue = JsonHelper.get(EraUmaEditor.save_data, path, null);
                String currentDisplayName = "";
                if (currentValue != null && item.choices != null) {
                    for (EditorItem.Choice choice : item.choices) {
                        if (currentValue.equals(choice.value)) {
                            currentDisplayName = choice.displayName;
                            break;
                        }
                    }
                }
                valueSpinner.setText(currentDisplayName, false);
            }
            valueSpinner.setOnItemClickListener((parent, view, position, id) -> {
                EditorItem.Choice selectedChoice = adapter.getItem(position);
                if (selectedChoice != null) {
                    JsonHelper.put(EraUmaEditor.save_data, path, selectedChoice.value);
                }
            });
        }
    }

    class DoubleEditTextHolder extends RecyclerView.ViewHolder implements DoubleViewHolder {
        private final TextInputLayout layout1, layout2;
        private final TextInputEditText editText1, editText2;
        private final TextView descriptionTextView;
        private final CustomTextWatcher watcher1, watcher2;

        DoubleEditTextHolder(@NonNull View itemView) {
            super(itemView);
            layout1 = itemView.findViewById(R.id.valueInputLayout1);
            editText1 = itemView.findViewById(R.id.valueEditText1);
            layout2 = itemView.findViewById(R.id.valueInputLayout2);
            editText2 = itemView.findViewById(R.id.valueEditText2);
            descriptionTextView = itemView.findViewById(R.id.descriptionTextView);
            watcher1 = new CustomTextWatcher();
            watcher2 = new CustomTextWatcher();
            editText1.addTextChangedListener(watcher1);
            editText2.addTextChangedListener(watcher2);
        }

        public void bind(EditorItem item1, EditorItem item2) {
            bindSingle(layout1, editText1, watcher1, item1);
            if (item2 != null) {
                layout2.setVisibility(View.VISIBLE);
                bindSingle(layout2, editText2, watcher2, item2);
            } else {
                layout2.setVisibility(View.GONE);
            }
            descriptionTextView.setVisibility(item1.description != null && !item1.description.isEmpty() ? View.VISIBLE : View.GONE);
            descriptionTextView.setText(item1.description);
        }

        private void bindSingle(TextInputLayout layout, TextInputEditText editText, CustomTextWatcher watcher, EditorItem item) {
            if (item == null) return;
            String path = resolveJsonPath(item.jsonPath);
            watcher.update(item, path);
            layout.setHint(item.label);
            boolean isDataAvailable = EraUmaEditor.save_data != null;
            editText.setEnabled(isDataAvailable);
            layout.setEnabled(isDataAvailable);
            layout.setPrefixText(item.prefix);
            layout.setSuffixText(item.suffix);
            switch (item.dataType) {
                case INT:
                    editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_SIGNED);
                    editText.setText(String.valueOf(JsonHelper.get(EraUmaEditor.save_data, path, 0)));
                    break;
                case FLOAT:
                    editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL | InputType.TYPE_NUMBER_FLAG_SIGNED);
                    editText.setText(String.valueOf(JsonHelper.get(EraUmaEditor.save_data, path, 0.0f)));
                    break;
                case STRING:
                    editText.setInputType(InputType.TYPE_CLASS_TEXT);
                    editText.setText(JsonHelper.get(EraUmaEditor.save_data, path, ""));
                    break;
            }
        }
    }

    class DoubleCheckboxViewHolder extends RecyclerView.ViewHolder implements DoubleViewHolder {
        private final MaterialCardView card1, card2;
        private final TextView label1, label2, descriptionTextView;
        private final MaterialCheckBox checkbox1, checkbox2;

        DoubleCheckboxViewHolder(@NonNull View itemView) {
            super(itemView);
            card1 = itemView.findViewById(R.id.card1);
            card2 = itemView.findViewById(R.id.card2);
            label1 = itemView.findViewById(R.id.labelTextView1);
            checkbox1 = itemView.findViewById(R.id.valueCheckBox1);
            label2 = itemView.findViewById(R.id.labelTextView2);
            checkbox2 = itemView.findViewById(R.id.valueCheckBox2);
            descriptionTextView = itemView.findViewById(R.id.descriptionTextView);
        }

        public void bind(EditorItem item1, EditorItem item2) {
            bindSingle(label1, checkbox1, item1);
            if (item2 != null) {
                card2.setVisibility(View.VISIBLE);
                bindSingle(label2, checkbox2, item2);
            } else {
                card2.setVisibility(View.GONE);
            }
            descriptionTextView.setVisibility(item1.description != null && !item1.description.isEmpty() ? View.VISIBLE : View.GONE);
            descriptionTextView.setText(item1.description);
        }

        private void bindSingle(TextView label, MaterialCheckBox checkBox, EditorItem item) {
            if (item == null) return;
            String path = resolveJsonPath(item.jsonPath);
            label.setText(item.label);
            boolean isDataAvailable = EraUmaEditor.save_data != null;
            checkBox.setEnabled(isDataAvailable);
            checkBox.setOnCheckedChangeListener(null);
            boolean isChecked = false;
            if (isDataAvailable) {
                Object value = JsonHelper.get(EraUmaEditor.save_data, path, item.booleanRepresentation == EditorItem.BooleanRepresentation.AS_BOOLEAN ? false : 0);
                isChecked = value instanceof Boolean ? (Boolean) value : value instanceof Number && ((Number) value).intValue() == 1;
            }
            checkBox.setChecked(isChecked);
            checkBox.setOnCheckedChangeListener((buttonView, b) -> {
                Object valueToPut = b;
                if (item.booleanRepresentation == EditorItem.BooleanRepresentation.AS_INT) {
                    valueToPut = b ? 1 : 0;
                }
                JsonHelper.put(EraUmaEditor.save_data, path, valueToPut);
            });
        }
    }

    class DoubleSpinnerViewHolder extends RecyclerView.ViewHolder implements DoubleViewHolder {
        private final TextInputLayout layout1, layout2;
        private final AutoCompleteTextView spinner1, spinner2;
        private final TextView descriptionTextView;

        DoubleSpinnerViewHolder(@NonNull View itemView) {
            super(itemView);
            layout1 = itemView.findViewById(R.id.valueInputLayout1);
            spinner1 = itemView.findViewById(R.id.valueSpinner1);
            layout2 = itemView.findViewById(R.id.valueInputLayout2);
            spinner2 = itemView.findViewById(R.id.valueSpinner2);
            descriptionTextView = itemView.findViewById(R.id.descriptionTextView);
        }

        public void bind(EditorItem item1, EditorItem item2) {
            bindSingle(layout1, spinner1, item1);
            if (item2 != null) {
                layout2.setVisibility(View.VISIBLE);
                bindSingle(layout2, spinner2, item2);
            } else {
                layout2.setVisibility(View.GONE);
            }
            descriptionTextView.setVisibility(item1.description != null && !item1.description.isEmpty() ? View.VISIBLE : View.GONE);
            descriptionTextView.setText(item1.description);
        }

        private void bindSingle(TextInputLayout layout, AutoCompleteTextView spinner, EditorItem item) {
            if (item == null) return;
            String path = resolveJsonPath(item.jsonPath);
            layout.setHint(item.label);
            boolean isDataAvailable = EraUmaEditor.save_data != null;
            spinner.setEnabled(isDataAvailable);
            layout.setEnabled(isDataAvailable);
            ArrayAdapter<EditorItem.Choice> adapter = new ArrayAdapter<>(itemView.getContext(), android.R.layout.simple_spinner_dropdown_item, item.choices);
            spinner.setAdapter(adapter);
            spinner.setOnItemClickListener(null);
            if (isDataAvailable) {
                Object currentValue = JsonHelper.get(EraUmaEditor.save_data, path, null);
                String currentDisplayName = "";
                if (currentValue != null && item.choices != null) {
                    for (EditorItem.Choice choice : item.choices) {
                        if (currentValue.equals(choice.value)) {
                            currentDisplayName = choice.displayName;
                            break;
                        }
                    }
                }
                spinner.setText(currentDisplayName, false);
            }
            spinner.setOnItemClickListener((parent, view, position, id) -> {
                EditorItem.Choice selectedChoice = adapter.getItem(position);
                if (selectedChoice != null) {
                    JsonHelper.put(EraUmaEditor.save_data, path, selectedChoice.value);
                }
            });
        }
    }

    private static class CustomTextWatcher implements TextWatcher {
        private EditorItem item;
        private String resolvedJsonPath;

        public void update(EditorItem item, String resolvedJsonPath) {
            this.item = item;
            this.resolvedJsonPath = resolvedJsonPath;
        }

        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {}

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {}

        @Override
        public void afterTextChanged(Editable s) {
            if (item == null || resolvedJsonPath == null) return;
            String input = s.toString();
            if (input.isEmpty() && item.dataType != EditorItem.DataType.STRING) return;
            try {
                switch (item.dataType) {
                    case INT:
                        int intVal = Integer.parseInt(input);
                        if (item.maxValue != null && intVal > item.maxValue) intVal = item.maxValue.intValue();
                        JsonHelper.put(EraUmaEditor.save_data, resolvedJsonPath, intVal);
                        break;
                    case FLOAT:
                        float floatVal = Float.parseFloat(input);
                        if (item.maxValue != null && floatVal > item.maxValue) floatVal = item.maxValue;
                        JsonHelper.put(EraUmaEditor.save_data, resolvedJsonPath, floatVal);
                        break;
                    case STRING:
                        JsonHelper.put(EraUmaEditor.save_data, resolvedJsonPath, input);
                        break;
                }
            } catch (NumberFormatException e) {
            }
        }
    }
}
