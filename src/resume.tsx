import { type JobExperience } from './.contentlayer/generated/types.js'
import { allJobExperiences } from './.contentlayer/generated/index.mjs'

function JobExperiences() {
    return (
        <section id='job-experience'>
            <h2>Job Experience</h2>
            <ul>
                {allJobExperiences.map((job: JobExperience, index: number) => (
                    <li key={index}>
                        <h3>{job.role}</h3>
                        <h4>{job.company}</h4>
                        <p>{job.description}</p>
                    </li>
                ))}
            </ul>
        </section>
    )
}

export default function Resume() {
    return (
        <html>
            <head>
                <link rel="stylesheet" href="resume.css" />
            </head>
            <body id='resume'>
                <h1>Resume</h1>
                <JobExperiences />
            </body>
        </html >
    )
}