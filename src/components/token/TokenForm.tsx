"use client";

import { ChangeEvent, useState } from "react";
import TokenPreview from "@/components/token/TokenPreview";

export default function TokenForm() {
  const [name, setName] = useState("");
  const [symbol, setSymbol] = useState("");
  const [supply, setSupply] = useState("");
  const [logoUrl, setLogoUrl] = useState("");

  function handleLogoChange(event: ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];

    if (!file) {
      setLogoUrl("");
      return;
    }

    const reader = new FileReader();

    reader.onload = () => {
      setLogoUrl(String(reader.result));
    };

    reader.readAsDataURL(file);
  }

  return (
    <section
      id="create-token"
      className="scroll-mt-20 bg-white px-6 py-20"
    >
      <div className="mx-auto max-w-6xl">
        <div className="mb-10 text-center">
          <span className="rounded-full bg-blue-100 px-4 py-2 text-sm font-semibold text-blue-700">
            Create your token
          </span>

          <h2 className="mt-5 text-4xl font-bold tracking-tight text-slate-950">
            Launch a B20 token
          </h2>

          <p className="mt-4 text-slate-600">
            Complete the fields below. No coding knowledge required.
          </p>
        </div>

        <div className="grid items-start gap-8 lg:grid-cols-[1.4fr_0.8fr]">
          <div className="rounded-3xl border border-slate-200 bg-slate-50 p-6 shadow-sm md:p-10">
            <div className="grid gap-6 md:grid-cols-2">
              <label className="flex flex-col gap-2">
                <span className="font-semibold text-slate-900">
                  Token name
                </span>

                <input
                  type="text"
                  value={name}
                  onChange={(event) => setName(event.target.value)}
                  placeholder="Example: Base Rocket"
                  className="rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-950 outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100"
                />
              </label>

              <label className="flex flex-col gap-2">
                <span className="font-semibold text-slate-900">Symbol</span>

                <input
                  type="text"
                  value={symbol}
                  onChange={(event) =>
                    setSymbol(event.target.value.toUpperCase())
                  }
                  maxLength={10}
                  placeholder="Example: BRT"
                  className="rounded-xl border border-slate-300 bg-white px-4 py-3 uppercase text-slate-950 outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100"
                />
              </label>

              <label className="flex flex-col gap-2">
                <span className="font-semibold text-slate-900">
                  Total supply
                </span>

                <input
                  type="number"
                  min="1"
                  value={supply}
                  onChange={(event) => setSupply(event.target.value)}
                  placeholder="1000000"
                  className="rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-950 outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100"
                />
              </label>

              <label className="flex flex-col gap-2">
                <span className="font-semibold text-slate-900">
                  Token logo
                </span>

                <input
                  type="file"
                  accept="image/png,image/jpeg,image/webp"
                  onChange={handleLogoChange}
                  className="rounded-xl border border-dashed border-slate-300 bg-white px-4 py-3 text-sm text-slate-600 file:mr-4 file:rounded-lg file:border-0 file:bg-blue-600 file:px-4 file:py-2 file:font-semibold file:text-white hover:file:bg-blue-700"
                />

                <span className="text-sm text-slate-500">
                  PNG, JPG or WEBP. Recommended: 512 × 512 px.
                </span>
              </label>
            </div>

            <label className="mt-6 flex flex-col gap-2">
              <span className="font-semibold text-slate-900">
                Description{" "}
                <span className="font-normal text-slate-500">
                  (optional)
                </span>
              </span>

              <textarea
                rows={4}
                placeholder="Tell users what your token is about."
                className="resize-none rounded-xl border border-slate-300 bg-white px-4 py-3 text-slate-950 outline-none transition focus:border-blue-500 focus:ring-4 focus:ring-blue-100"
              />
            </label>

            <button
              type="button"
              className="mt-8 w-full rounded-xl bg-blue-600 px-6 py-4 text-lg font-semibold text-white shadow-lg shadow-blue-600/20 transition hover:bg-blue-700"
            >
              Continue
            </button>
          </div>

          <TokenPreview
            name={name || "Your Token"}
            symbol={symbol || "TOKEN"}
            supply={
              supply ? Number(supply).toLocaleString() : "1,000,000"
            }
            logoUrl={logoUrl}
          />
        </div>
      </div>
    </section>
  );
}