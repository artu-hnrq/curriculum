import { defineDocumentType, makeSource } from '@contentlayer/source-files'

import rehypeDocument from 'rehype-document'
import rehypeFormat from 'rehype-format'


// const Resume = defineDocumentType(() => ({
//     name: 'Resume',
//     filePathPattern: 'resume.md',
//     fields: {

//     },
//     isSingleton: true,
// }))

const JobExperience = defineDocumentType(() => ({
    name: 'JobExperience',
    filePathPattern: `curriculum/**/*.md`,
    fields: {
        role: { type: 'string', required: true },
        employment_type: { type: 'string', required: true },
        company: { type: 'string', required: true },
        location: { type: 'string', required: true },
        start_date: { type: 'string', required: true },
        end_date: { type: 'string', default: 'Present' },
        skills: { type: 'list', of: { type: 'string' }, required: true },
        description: { type: 'string', required: true },
        impact: { type: 'list', of: { type: 'string' }, required: false },
    }
}))


export default makeSource({
    contentDirPath: 'content',
    contentDirExclude: ['resume.md', 'summary.md'],
    documentTypes: [
        JobExperience,
    ],
    markdown: {
        remarkPlugins: [
            //// Default plugins:
            // remarkParse,
            // remarkFrontmatter,
            // remark2rehype,
        ],
        rehypePlugins: [
            // [rehypeDocument as any, { css: [`resume.css`] }],
            // [rehypeFormat],
            //// Default plugins:
            // rehypeStringify,
        ],
    },
})