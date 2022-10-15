import '../styles/globals.css'
import { DataProvider } from './GlobalState'

function MyApp({ Component, pageProps }) {
  return (
    <DataProvider>
      <Component {...pageProps} />
    </DataProvider>
  )

}

export default MyApp
