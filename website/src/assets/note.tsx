import MarkdownViewer from "../components/MarkdownViewer";

const Note = () => {
    return (
        <div className="p-4 bg-white rounded shadow text-black">
            <MarkdownViewer path="/readme/Notes.md" />
        </div>
    );
};

export default Note;