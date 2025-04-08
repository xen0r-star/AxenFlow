import { useEffect, useState } from "react";
import ReactMarkdown from "react-markdown";

type MarkdownViewerProps = {
  path: string;
};

const MarkdownViewer: React.FC<MarkdownViewerProps> = ({ path }) => {
  const [markdown, setMarkdown] = useState<string>("");

  useEffect(() => {
    fetch(path)
      .then((res) => res.text())
      .then((text) => setMarkdown(text))
      .catch((err) => {
        console.error("Erreur de chargement du fichier Markdown:", err);
        setMarkdown("# Erreur : fichier introuvable");
      });
  }, [path]);

  return (
    <div className="prose max-w-none">
      <ReactMarkdown>{markdown}</ReactMarkdown>
    </div>
  );
};

export default MarkdownViewer;
