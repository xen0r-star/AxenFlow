import MarkdownViewer from "../components/MarkdownViewer";

const Teacher = () => {
    return (
        <div className="p-4 bg-white rounded shadow text-black">
            <MarkdownViewer path="/readme/Enseignants.md" />
        </div>
    );
};

export default Teacher;