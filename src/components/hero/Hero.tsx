export default function Hero() {
  return (
    <section className="relative overflow-hidden bg-slate-50">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_top,_rgba(0,82,255,0.14),_transparent_38%)]" />

      <div className="relative mx-auto flex min-h-[calc(100vh-4rem)] max-w-7xl flex-col items-center justify-center px-6 py-20 text-center">
        <span className="rounded-full border border-blue-200 bg-white px-4 py-2 text-sm font-semibold text-blue-700 shadow-sm">
          Built for Base
        </span>

        <h1 className="mt-6 max-w-4xl text-5xl font-bold tracking-tight text-slate-950 md:text-7xl">
          Launch your B20 token
          <span className="block text-blue-600">without the complexity</span>
        </h1>

        <p className="mt-6 max-w-2xl text-lg leading-8 text-slate-600">
          Create, customize and launch a B20 token on Base through a simple
          guided experience made for beginners.
        </p>

        <div className="mt-10 flex flex-col gap-4 sm:flex-row">
          <a
  href="#create-token"
  className="rounded-xl bg-blue-600 px-8 py-4 text-lg font-semibold text-white shadow-lg shadow-blue-600/20 transition hover:bg-blue-700"
>
  Create B20 Token
</a>

          <button className="rounded-xl border border-slate-300 bg-white px-8 py-4 text-lg font-semibold text-slate-800 transition hover:border-blue-300 hover:text-blue-700">
            Explore B20
          </button>
        </div>

        <div className="mt-12 grid w-full max-w-3xl grid-cols-1 gap-4 text-left sm:grid-cols-3">
          {[
            ["Fast", "Guided token creation"],
            ["Simple", "No coding required"],
            ["Base-native", "Built for Base users"],
          ].map(([title, text]) => (
            <div
              key={title}
              className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm"
            >
              <p className="font-semibold text-slate-950">{title}</p>
              <p className="mt-1 text-sm text-slate-600">{text}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}