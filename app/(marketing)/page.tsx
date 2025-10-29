import { Header } from "./header"; 
export default function MarketingPage() {
  return (
    <div>
      <Header />
      <main>
        <div className="flex flex-col items-center justify-center p-8">
          <h1 className="text-3xl font-bold">
            Welcome to Duo Clone
          </h1>
          <p className="text-lg text-muted-foreground mt-2">
            This is the main marketing page.
          </p>
        </div>
      </main>
    </div>
  );
}