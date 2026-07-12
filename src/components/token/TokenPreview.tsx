type TokenPreviewProps = {
  name?: string;
  symbol?: string;
  supply?: string;
  logoUrl?: string;
};

export default function TokenPreview({
  name = "Your Token",
  symbol = "TOKEN",
  supply = "1,000,000",
  logoUrl,
}: TokenPreviewProps) {
  return (
    <aside className="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
      <p className="text-sm font-semibold uppercase tracking-wider text-blue-600">
        Live preview
      </p>

      <div className="mt-6 flex items-center gap-4">
        <div className="flex h-16 w-16 items-center justify-center overflow-hidden rounded-2xl bg-blue-100 text-2xl font-bold text-blue-700">
          {logoUrl ? (
            <img
              src={logoUrl}
              alt={`${name} logo`}
              className="h-full w-full object-cover"
            />
          ) : (
            symbol.slice(0, 2).toUpperCase()
          )}
        </div>

        <div>
          <h3 className="text-2xl font-bold text-slate-950">{name}</h3>
          <p className="mt-1 font-semibold uppercase text-slate-500">
            {symbol}
          </p>
        </div>
      </div>

      <div className="mt-8 space-y-4">
        <div className="flex items-center justify-between border-b border-slate-100 pb-4">
          <span className="text-slate-500">Total supply</span>
          <span className="font-semibold text-slate-950">{supply}</span>
        </div>

        <div className="flex items-center justify-between border-b border-slate-100 pb-4">
          <span className="text-slate-500">Network</span>
          <span className="rounded-full bg-blue-100 px-3 py-1 text-sm font-semibold text-blue-700">
            Base
          </span>
        </div>

        <div className="flex items-center justify-between">
          <span className="text-slate-500">Standard</span>
          <span className="font-semibold text-slate-950">B20</span>
        </div>
      </div>
    </aside>
  );
}