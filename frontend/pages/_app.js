import "../styles/globals.css";

function MyApp({ Component, pageProps }) {
  return (
    <div className="flex">
      <div className="w-1/6 p-10 h-screen">
        <div id="pages">
          <div>Portfolio</div>
          <div className="pt-3">Bridge</div>
          <div className="pt-3">Settings</div>
        </div>
      </div>
      <div className="w-5/6 h-screen" style={{ background: "#E7EBEF" }}>
        <Component {...pageProps} />
      </div>
    </div>
  );
}

export default MyApp;
