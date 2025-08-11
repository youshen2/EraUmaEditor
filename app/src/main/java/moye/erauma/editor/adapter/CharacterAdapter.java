package moye.erauma.editor.adapter; // 建议为 adapter 创建一个新包

import android.content.Context;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import java.util.List;

import moye.erauma.editor.EraUmaEditor;
import moye.erauma.editor.R;
import moye.erauma.editor.activity.CharacterInfoActivity;
import moye.erauma.editor.model.CharacterItem;

public class CharacterAdapter extends RecyclerView.Adapter<CharacterAdapter.CharacterViewHolder> {

    private List<CharacterItem> characterList;
    private final Context context;

    public CharacterAdapter(Context context, List<CharacterItem> characterList) {
        this.context = context;
        this.characterList = characterList;
    }

    @NonNull
    @Override
    public CharacterViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(context).inflate(R.layout.item_character, parent, false);
        return new CharacterViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull CharacterViewHolder holder, int position) {
        CharacterItem currentCharacter = characterList.get(position);

        holder.nameTextView.setText(currentCharacter.getName());

        holder.itemView.setOnClickListener(v -> {
            EraUmaEditor.current_character_id = Integer.parseInt(currentCharacter.getId());
            Intent intent = new Intent(context, CharacterInfoActivity.class);
            context.startActivity(intent);
        });
    }

    public void filterList(List<CharacterItem> filteredList) {
        characterList = filteredList;
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() {
        return characterList.size();
    }

    public static class CharacterViewHolder extends RecyclerView.ViewHolder {
        TextView nameTextView;

        public CharacterViewHolder(@NonNull View itemView) {
            super(itemView);
            nameTextView = itemView.findViewById(R.id.character_name);
        }
    }
}
