import MarkdownViewer from "../components/MarkdownViewer";

const Student = () => {
    return (
        <div className="p-4 bg-white rounded shadow text-black">
            <MarkdownViewer path="/readme/Etudiants.md" />
        </div>
    );
};

export default Student;