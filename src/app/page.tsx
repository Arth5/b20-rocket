import Hero from "@/components/hero/Hero";
import Navbar from "@/components/layout/Navbar";
import TokenForm from "@/components/token/TokenForm";

export default function Home() {
  return (
    <main className="min-h-screen bg-slate-50">
      <Navbar />
      <Hero />
      <TokenForm />
    </main>
  );
}