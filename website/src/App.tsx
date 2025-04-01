import { useState } from "react";
import Introduction from "./assets/introduction";
import Email from "./assets/email";
import Mission from "./assets/mission";
import Note from "./assets/note";
import Student from "./assets/student";
import Teacher from "./assets/teacher";

import logo from "/logo.png";
import github from "/github-mark-white.svg";

const App = () => {
  const [selectedComponent, setSelectedComponent] = useState(<Introduction />);

  return (
    <div className="flex h-screen w-screen">
      {/* Sidebar */}
      <nav className="w-1/5 bg-[#1A3836] text-white relative">
        <img src={logo} alt="Logo AxenFlow" className="p-4 pb-6 mb-3 bg-[#00000055]" />

        <div className="ml-4">
          <h2 className="text-xl font-bold mt-4">Accueil</h2>
          <ul className="space-y-2">
            <li className="mr-4 hover:bg-[#112423] rounded-xs">
              <button
                onClick={() => setSelectedComponent(<Introduction />)}
                className="block w-auto max-w-min text-left p-2 rounded"
              >
                Introduction
              </button>
            </li>
          </ul>

          <h2 className="text-xl font-bold mt-4">Guide d'utilisation</h2>
          <ul className="space-y-2">
            <li className="mr-4 hover:bg-[#112423] rounded-xs">
              <button
                onClick={() => setSelectedComponent(<Introduction />)}
                className="block w-full text-left p-2 rounded"
              >
                Introduction
              </button>
            </li>
            <li className="mr-4 hover:bg-[#112423] rounded-xs">
              <button
                onClick={() => setSelectedComponent(<Student />)}
                className="block w-full text-left p-2 rounded"
              >
                Étudiants
              </button>
            </li>
            <li className="mr-4 hover:bg-[#112423] rounded-xs">
              <button
                onClick={() => setSelectedComponent(<Teacher />)}
                className="block w-full text-left p-2 rounded"
              >
                Enseignants
              </button>
            </li>
            <li className="mr-4 hover:bg-[#112423] rounded-xs">
              <button
                onClick={() => setSelectedComponent(<Mission />)}
                className="block w-full text-left p-2 rounded"
              >
                Mission
              </button>
            </li>
            <li className="mr-4 hover:bg-[#112423] rounded-xs">
              <button
                onClick={() => setSelectedComponent(<Note />)}
                className="block w-full text-left p-2 rounded"
              >
                Notes des étudiants
              </button>
            </li>
            <li className="mr-4 hover:bg-[#112423] rounded-xs">
              <button
                onClick={() => setSelectedComponent(<Email />)}
                className="block w-full text-left p-2 rounded"
              >
                Email
              </button>
            </li>
          </ul>

          <h2 className="text-xl font-bold mt-4">Licence</h2>
          <ul className="space-y-2">
            <li className="mr-4 hover:bg-[#112423] rounded-xs">
              <button
                onClick={() => window.open('https://github.com/xen0r-star/AxenFlow/blob/main/LICENSE', '_blank')}
                className="block w-auto text-left p-2 rounded"
              >
                Licence
              </button>
            </li>
          </ul>
        </div>

        <div className="bottom-0 right-0 absolute mb-2 mr-4">
          <a href="https://github.com/xen0r-star" target="_blank" rel="noopener noreferrer">
            <img src={github} alt="logo github" className="w-10 cursor-pointer" />
          </a>
        </div>
      </nav>

      {/* Contenu Dynamique */}
      <div className="w-4/5 p-6 bg-gray-100">{selectedComponent}</div>
    </div>
  );
};

export default App;
