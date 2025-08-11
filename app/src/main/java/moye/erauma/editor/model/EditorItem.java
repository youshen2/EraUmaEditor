package moye.erauma.editor.model;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.List;
import java.util.Objects;

public class EditorItem {

    public static class Choice {
        public final Object value;
        public final String displayName;

        public Choice(@NonNull Object value, @NonNull String displayName) {
            this.value = value;
            this.displayName = displayName;
        }

        @NonNull
        @Override
        public String toString() {
            return displayName;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            Choice choice = (Choice) o;
            return value.equals(choice.value) && displayName.equals(choice.displayName);
        }

        @Override
        public int hashCode() {
            return Objects.hash(value, displayName);
        }
    }

    public enum LayoutType {
        SINGLE,
        DOUBLE
    }

    public enum DataType {
        INT, FLOAT, STRING, BOOLEAN, CHOICE
    }

    public enum BooleanRepresentation {
        AS_INT,
        AS_BOOLEAN
    }

    @NonNull public final String label;
    @Nullable public final String description;
    @NonNull public final String jsonPath;
    @NonNull public final DataType dataType;
    @Nullable public final Float maxValue;
    @Nullable public final String prefix;
    @Nullable public final String suffix;
    @NonNull public final LayoutType layoutType;
    @Nullable public final List<Choice> choices;
    @NonNull public final BooleanRepresentation booleanRepresentation;

    private EditorItem(@NonNull String label, @Nullable String description, @NonNull String jsonPath, @NonNull DataType dataType, @Nullable Float maxValue, @Nullable String prefix, @Nullable String suffix, @NonNull LayoutType layoutType, @Nullable List<Choice> choices, @NonNull BooleanRepresentation booleanRepresentation) {
        this.label = label;
        this.description = description;
        this.jsonPath = jsonPath;
        this.dataType = dataType;
        this.maxValue = maxValue;
        this.prefix = prefix;
        this.suffix = suffix;
        this.layoutType = layoutType;
        this.choices = choices;
        this.booleanRepresentation = booleanRepresentation;
    }

    public static class Builder {
        private final String label;
        private final String jsonPath;
        private final DataType dataType;
        private String description;
        private Float maxValue;
        private String prefix;
        private String suffix;
        private LayoutType layoutType = LayoutType.SINGLE;
        private List<Choice> choices;
        private BooleanRepresentation booleanRepresentation = BooleanRepresentation.AS_INT;

        public Builder(String label, String jsonPath, DataType dataType) {
            this.label = label;
            this.jsonPath = jsonPath;
            this.dataType = dataType;
        }

        public Builder setDescription(String description) {
            this.description = description;
            return this;
        }

        public Builder setPrefix(String prefix) {
            this.prefix = prefix;
            return this;
        }

        public Builder setSuffix(String suffix) {
            this.suffix = suffix;
            return this;
        }

        public Builder setMaxValue(float maxValue) {
            this.maxValue = maxValue;
            return this;
        }

        public Builder setLayoutType(LayoutType layoutType) {
            this.layoutType = layoutType;
            return this;
        }

        public Builder setChoices(List<Choice> choices) {
            if (this.dataType != DataType.CHOICE) {
                return this;
            }
            this.choices = choices;
            return this;
        }

        public Builder setBooleanRepresentation(BooleanRepresentation representation) {
            if (this.dataType != DataType.BOOLEAN) {
                return this;
            }
            this.booleanRepresentation = representation;
            return this;
        }

        public EditorItem build() {
            return new EditorItem(label, description, jsonPath, dataType, maxValue, prefix, suffix, layoutType, choices, booleanRepresentation);
        }
    }
}
