import fs from 'fs'
import remarkParse from 'remark-parse'
import remark2rehype from 'remark-rehype'
import rehypeDocument from 'rehype-document'
import rehypeFormat from 'rehype-format'
import rehypeStringify from 'rehype-stringify'
import { unified } from 'unified'
import { assert } from 'console'


async function processContent(markdown: string) {
    return unified()
        .use(remarkParse)
        .use(remark2rehype)
        .use(rehypeDocument, {
            css: [`../resume.css`],
        })
        .use(rehypeFormat, { indent: 4 })
        .use(rehypeStringify)
        .process(markdown)
}

async function generateHTML(content: string, output: string) {
    const htmlContent = await processContent(fs.readFileSync(content, 'utf-8'))
    fs.writeFileSync(output, htmlContent.toString())
}


// Manage arguments
const files = process.argv.slice(2)
assert(files.length >= 1, 'Usage: node main.js <input.md> [<output.html>]')

const input = files[0]
const output = files.at(1)
assert(fs.existsSync(input), `${input} file not found`)

generateHTML(
    input,
    output ?? 'dist/resume.html'
)