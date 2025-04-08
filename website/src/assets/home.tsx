import MarkdownViewer from "../components/MarkdownViewer";

const Home = () => {
    return (
        <div className="p-4 bg-white rounded shadow text-black">
            <MarkdownViewer path="/readme/Home.md" />
        </div>
    );
};

export default Home;