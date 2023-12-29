import fs from 'fs'
import { assert } from 'console'


async function importContent() {
    try {
        const { resume } = await import('./.contentlayer/generated/index.mjs')
        return resume

    } catch (e) {
        throw new Error(`You should first process markdown files`)
    }
}

async function generateHTML(output: string) {
    const resume = await importContent()
    fs.writeFileSync(output, resume.body.html)
}


// Manage arguments
const files = process.argv.slice(2)
assert(files.length == 1, 'Usage: node main.js <output.html>')

const output = files[0]

generateHTML(
    output ?? 'dist/resume.html'
)