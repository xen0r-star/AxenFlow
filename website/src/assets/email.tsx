const Email = () => {
    return (
        <div className="p-4 bg-white shadow-md rounded-lg">
            <h2 className="text-xl font-semibold mb-2">Email</h2>
            <p className="mb-4">Voici un exemple d'email que vous pouvez envoyer :</p>
            <div className="bg-gray-100 p-4 rounded-lg border border-gray-300">
                <p>Bonjour,</p>
                <p>Je voulais vous rappeler notre réunion prévue pour demain à 10h.</p>
                <p>Merci !</p>
            </div>
        </div>
    );
};

export default Email;