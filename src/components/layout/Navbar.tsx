export default function Navbar() {
  return (
    <nav className="w-full border-b border-blue-200 bg-white">
      <div className="mx-auto flex h-16 max-w-7xl items-center justify-between px-6">
        <h1 className="text-2xl font-bold text-blue-600">
          🚀 B20 Rocket
        </h1>

        <button className="rounded-lg bg-blue-600 px-5 py-2 font-semibold text-white hover:bg-blue-700">
          Connect Wallet
        </button>
      </div>
    </nav>
  );
}