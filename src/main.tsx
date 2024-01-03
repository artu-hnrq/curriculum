import fs from 'fs'
import { assert } from 'console'
import ReactDOMServer from 'react-dom/server';

import Resume from './resume.js'


async function generateHTML(output: string) {
    const html = ReactDOMServer.renderToString(<Resume />)
    fs.writeFileSync(output, html)
}


// Manage arguments
const files = process.argv.slice(2)
assert(files.length == 1, 'Usage: node main.js <output.html>')

const output = files[0]

generateHTML(
    output ?? 'dist/resume.html'
)