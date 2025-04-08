import MarkdownViewer from "../components/MarkdownViewer";

const Email = () => {
    return (
        <div className="p-5 bg-white rounded shadow text-black">
            <MarkdownViewer path="/readme/Email.md" />
        </div>
    );
};

export default Email;