import MarkdownViewer from "../components/MarkdownViewer";

const Mission = () => {
    return (
        <div className="p-4 bg-white rounded shadow text-black">
            <MarkdownViewer path="/readme/Missions.md" />
        </div>
    );
};

export default Mission;