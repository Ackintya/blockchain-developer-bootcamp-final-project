import '../styles/globals.css'
import Link from 'next/link'

function MyApp({ Component, pageProps }) {
 
  return (
    <div>
      <nav className="border-b p-6">
        <p className="text-4xl font-bold">QuadFund Me</p>
        <div className="flex mt-4">
          <Link href="/"  title="water">
            <a className="mr-4 text-pink-500">
              Home
            </a>
          </Link>
          <Link href="/create-item">
            <a className="mr-6 text-pink-500">
              Add your Project
            </a>
          </Link>
          <Link href="/my-assets">
            <a className="mr-6 text-pink-500">
              My Pools
            </a>
          </Link>
          <Link href="/create-pool">
            <a className="mr-6 text-pink-500">
              Create Pool
            </a>
          </Link>
          <Link href="/all-pool">
            <a className="mr-6 text-pink-500">
              All Pools
            </a>
          </Link>
        </div>
      </nav>
      <Component {...pageProps} />
    </div>
  )
}

export default MyApp