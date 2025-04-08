import MarkdownViewer from "../components/MarkdownViewer";

const Introduction = () => {
    return (
        <div className="p-4 bg-white rounded shadow text-black">
            <MarkdownViewer path="/readme/Introduction.md" />
        </div>
    );
};

export default Introduction;
