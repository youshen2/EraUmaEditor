package moye.erauma.editor.model;

public class CharacterItem {
    private String id;
    private String name;

    public CharacterItem(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }
}
