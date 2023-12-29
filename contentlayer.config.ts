import { defineDocumentType, makeSource } from '@contentlayer/source-files'

import rehypeDocument from 'rehype-document'
import rehypeFormat from 'rehype-format'


const Resume = defineDocumentType(() => ({
    name: 'Resume',
    filePathPattern: 'resume.md',
    fields: {

    },
    isSingleton: true,
}))


export default makeSource({
    contentDirPath: 'content',
    documentTypes: [
        Resume,
    ],
    markdown: {
        remarkPlugins: [
            //// Default plugins:
            // remarkParse,
            // remarkFrontmatter,
            // remark2rehype,
        ],
        rehypePlugins: [
            [rehypeDocument as any, { css: [`resume.css`] }],
            [rehypeFormat],
            //// Default plugins:
            // rehypeStringify,
        ],
    },
})