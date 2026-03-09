# GitHub Classroom Tools

This repository is an index of tools created to assist instructors in managing programming courses with GitHub Classroom.

These tools are implemented in Java and require JDK 21 or later.

Table of Contents

- [Tools Included in This Suite](#tools-included-in-this-suite)
- [TL;DR. Cheat Sheet](#tldr-cheat-sheet)
- [Motivation for these Tools](#motivation-for-these-tools)
    - [Feature 1: Fast Review of Student Submissions](#feature-1-fast-review-of-student-submissions)
    - [Feature 2: Fast Delivery of Solutions to Students](#feature-2-fast-delivery-of-solutions-to-students)
- [Installation](#installation)
- [Course Workflow](#course-workflow)
    - [Phase 1. At the beginning of the course](#phase-1-at-the-beginning-of-the-course)
    - [Phase 2. Managing Changes](#phase-2-managing-changes)
    - [Phase 3. At the end of each assignment](#phase-3-at-the-end-of-each-assignment)
        - [Manual selection](#manual-selection)
        - [Automatic selection](#automatic-selection)
    - [Phase 4. At the end of the course](#phase-4-at-the-end-of-the-course)
- [Access to Resources](#access-to-resources)
    - [Obtaining the GitHub Token](#obtaining-the-github-token)
    - [Obtaining the Roster File](#obtaining-the-roster-file)
- [License](#license)


## Tools Included in This Suite

The [GitHub Classroom Tools](https://github.com/stars/raul-izquierdo/lists/github-classroom-tools) suite includes the following tools:
- [roster.jar](https://github.com/raul-izquierdo/roster). A tool for creating and maintaining the GitHub Classroom roster.
- [teams.jar](https://github.com/raul-izquierdo/teams). A tool for creating and maintaining GitHub teams for each lab group.
- [solutions.jar](https://github.com/raul-izquierdo/solutions). A tool for showing or hiding an assignment solution to a lab group.
- [merge-gits.jar](https://github.com/raul-izquierdo/merge-gits). A tool for merging the starter code of an assignment with its solution.

The first three tools are designed to work together and are described in this index. The last tool, [merge-gits](https://github.com/raul-izquierdo/merge-gits), is simpler and its usage falls outside the workflow presented here. Instead, it serves as a cross-cutting auxiliary tool when working with solution code repositories. For more information about its usage, consult [its repository](https://github.com/raul-izquierdo/merge-gits) on GitHub.

Therefore, the rest of this document focuses on the combined usage of the first three tools: `roster.jar`, `teams.jar`, and `solutions.jar`. Detailed documentation for each tool separately can be found in their respective repositories, but it is recommended to **read this index first** to understand the complete workflow and when to use each tool.

> Although not part of this suite, since they serve more general purposes, the following projects may also be useful for simplifying common repository management tasks:
> - [grant](https://github.com/raul-izquierdo/grant). A tool for granting repository permissions to GitHub users or teams in batch.
> - [repos-status](https://github.com/raul-izquierdo/repos-status). A script that recursively scans all Git repositories in a local directory tree and reports their synchronization status.
>
> These projects are recommended to be consulted, together with [merge-gits](https://github.com/raul-izquierdo/merge-gits), after reading thish documentation, as their usage is simpler and does not form part of a specific workflow.

## TL;DR. Cheat Sheet

Already familiar with the documentation and tools, and just need a quick reference? Here is a **summary** of when to use each tool:

- **Beginning of the course**: Create the roster:
    ```bash
    java -jar roster.jar create
    ```
- **After students accept the first assignment**: Create the teams:
    ```bash
    update.cmd   # Windows

    ./update.sh  # Linux/Mac
    ```
- You have just finished explaining the solution to an assignment and want to allow the students in the current class to be able to study that code **on their own computers right now**? Grant them access to the solution:
    ```bash
    java -jar solutions.jar
    ```
- There are **changes in enrollment** or lab-group assignments? Run `update.cmd`/`update.sh` again.
- The **course has ended**? Delete the teams and their students to prepare the organization for the next intake:
    ```bash
    java -jar teams.jar --clean
    ```

The later section [Course Workflow](#course-workflow) explains this in more detail.

## Motivation for these Tools

These tools were developed to support a workflow for lab sessions consisting of:
- In each session, students are given an exercise (Github repository) that they must complete and submit before the next session.
- At the beginning of the following session, the solution is explained (another Github repository) and students can ask questions.
- Immediately after the solution is explained, the next exercise is assigned and students work on it during the remainder of the class.

These tools were created with two main objectives in mind:
- Fast **review** of student submissions by the instructor. This objective is achieved with a single tool:
    - [roster.jar](https://github.com/raul-izquierdo/roster).
- Fast **delivery of solutions** to students during lab sessions. This objective is achieved with two tools:
    - [teams.jar](https://github.com/raul-izquierdo/teams).
    - [solutions.jar](https://github.com/raul-izquierdo/solutions).

Depending on the instructor's needs, you may choose to add only the first feature to your workflow (requiring only `roster.jar`), or incorporate both features (using all three programs). In other words, the first feature is **independent** of the second, but the second depends on the first.

If you are only interested in the first feature, you only need to read the documentation of [roster.jar](https://github.com/raul-izquierdo/roster) and can ignore this repository, which is dedicated to the usage of **both features** together.


### Feature 1: Fast Review of Student Submissions

Before these tools were implemented, reviewing student submissions was a slow and cumbersome process:
- Students submitted their projects as ZIP files. It was extremely time-consuming for the instructor to **download, extract, and import** each submission for review (often encountering import errors because students could choose their own development environment).
- Additionally, the instructor then had to write and send a **detailed report** to each student outlining the errors found, with enough detail for the student to understand and avoid repeating them.

GitHub Classroom allows you to review student submissions online, switching between them **instantly** without downloading or installing anything locally.
- This speed enables reviewing submissions during the same class while students work on the next exercise. Instead of writing a report, you can even ask students to discuss improvements in person, enabling much more **effective two-way interaction**.

However, GitHub Classroom requires maintaining the roster as students join, leave, or change lab groups. The [roster.jar](https://github.com/raul-izquierdo/roster) tool addresses this challenge by automating roster updates.

### Feature 2: Fast Delivery of Solutions to Students

During lab sessions, after explaining the solution to the class, it would be beneficial for students to have a few minutes to review the solution files on their own computers at their own pace, allowing them to better understand the material, compare it with their own work, and ask follow-up questions.

However, this was impractical because the process was too slow: students had to visit the course website, download, extract, and import a project into their IDE—disrupting the lab session flow. Consequently, students were asked to review solutions at home instead.

This suite of tools enables students to view solutions on their own computers **immediately** after the explanation with a single click and **no installation** required. This is achieved using two tools:
- [teams.jar](https://github.com/raul-izquierdo/teams): creates and updates GitHub Teams for each lab group, enabling group-based permissions.
- [solutions.jar](https://github.com/raul-izquierdo/solutions): used to show or hide an assignment's solution for a lab group.

## Installation

To use these tools, download each tool's JAR from its repository. This repository includes download scripts (`get-jars.sh` or `get-jars.cmd`) that automate this process. Here are the recommended installation steps:

1. Clone this repository:
   ```bash
   git clone https://github.com/raul-izquierdo/classroom-tools.git
   cd classroom-tools
   ```

2. Run the script for the appropriate operating system to download (or update) the tools' JARs.
   ```bash
   # Windows
   get-jars.cmd

   # Linux/Mac
   ./get-jars.sh
   ```

3. (Optional) Create a `.env` file with the organization name and the GitHub Classroom API access token.
    ```env
    GITHUB_ORG=<organization that contains the repositories with the solutions>
    GITHUB_TOKEN=<GitHub token>
    STUDENTS_FILE=<name of the file with the list of students>
    STUDENTS_FORMAT=<format of the previous file>
    ```

    This step is optional but recommended, as it allows you to run the tools without specifying command-line flags. This repository includes a `.env.example` file you can copy and edit.

    Here's how to obtain values for the above variables:
    - The organization specified in _GITHUB_ORG_ should **contain the solution repositories**. This may differ from the organization linked to GitHub Classroom. Some instructors prefer storing solutions in a separate organization from assignments (recommended). In that case, specify the organization containing the solutions here.
    - For information on obtaining the _token_, see [Obtaining the GitHub Token](#obtaining-the-github-token).
    - The _STUDENTS_FILE_ should contain a list of enrolled students and their lab groups. How you obtain this list depends on your institution. For example, at the University of Oviedo, the SIES academic management system provides this file, and the values should be:
        ```csv
        STUDENTS_FILE="alumnosMatriculados.xls"
        STUDENTS_FORMAT="sies"
        ```
        See [Student file formats](https://github.com/raul-izquierdo/roster?tab=readme-ov-file#student-file-formats) for more information about other options.

4. Edit the `schedule.csv` file with the schedules for your assigned groups (it initially contains sample data). If no duration is specified, a default of 2 hours (2h) is assumed. Example:
    ```csv
    01, monday, 21:00
    02, tuesday, 14:00, 3h
    i01, wednesday, 16:00, 45m
    ```

## Course Workflow

Detailed usage instructions for each tool are in their respective repositories. Here's the recommended workflow:
- [Phase 1. At the beginning of the course](#phase-1-at-the-beginning-of-the-course): Create the GitHub Classroom roster to enable sending assignments.
- [Phase 2. Managing Changes](#phase-2-managing-changes): Update the roster and Teams when enrollment or lab-group assignments change.
- [Phase 3. At the end of each assignment](#phase-3-at-the-end-of-each-assignment): Grant each group permission to view the assignment solution.
- [Phase 4. At the end of the course](#phase-4-at-the-end-of-the-course): Delete the Teams to clean the organization for the next course (while preserving starter code and solutions).

> NOTE: The examples below assume you've created the `.env` file with the required variables. If not, provide these values using command-line flags when running the tools.


### Phase 1. At the beginning of the course

At the beginning of the course, the classroom roster must be created. This roster is the list of students who can receive assignments.

Follow these steps in this phase:

1. Obtain the **student roster file** from your institution. This is the file you'll assign to the _STUDENTS_FILE_ variable (e.g., `alumnosMatriculados.xls`).

2. **Create the roster** from the student list using `roster.jar`.

    Before creating the roster, if you don't teach all groups, specify which groups you teach to filter students. Create a `schedule.csv` file (if not already created during installation) and pass it using the `-s` option. See [groups file format](https://github.com/raul-izquierdo/roster#groups-file-format) for details. The following examples will use this file.

    Using the `.env` file from above, create the roster with:
    ```bash
    java -jar roster.jar create
    ```

    Example output:
    ```bash
    $ java -jar roster.jar create

    ## Students to add to the roster

    Instructions:
    - Go to the Classroom page.
    - Click the 'Students' tab.
    - Click the 'Update Students' button.
    - Select and copy all the lines below at once, then paste them into the 'Create your roster manually' text area.

    Izquierdo Castanedo, Raúl (01)
    González Pérez, Juan (i02)
    Alonso, Mariano (01)
    Rodríguez, Javier (02)
    ```

    Each generated identifier includes the student’s lab group in parentheses, which will make it easier to filter in the Classroom web interface.

3. **Enter the roster manually**. Since GitHub Classroom doesn't offer an API for roster maintenance, copy the output from the previous step and paste it into the web interface. `roster.jar` provides step-by-step instructions.


### Phase 2. Managing Changes

Repeat this phase when:
- **Enrollment or lab-group assignments change** (updates to `alumnosMatriculados.xls` or equivalent)
- **After a student accepts the first assignment** of the course

**IMPORTANT**: Run this phase for each group **between** when they _accept_ the first assignment and when you _explain_ its solution. GitHub Classroom only links students' personal GitHub accounts to the roster after they accept their first assignment, and this is needed to create teams for managing solution access.

To manage these changes, run:
```cmd
update.cmd   # Windows
```
```bash
./update.sh  # Linux/Mac
```

The output indicates whether changes are needed. If so, follow the provided instructions to update the roster in GitHub Classroom and the Teams.


### Phase 3. At the end of each assignment

After students submit an assignment and you've explained the solution, use `solutions.jar` to grant each group permission to access the solution repository.

You can do this in two ways: _manual_ selection and _automatic_ selection (recommended).

#### Manual selection

To manually select the group and solution, run:
```bash
java -jar solutions.jar
```

This command displays a menu for selecting which group and solution to show or hide. Once completed, students will have access to the specified repository.

#### Automatic selection

This is the recommended option, as the tool automatically determines the group and solution—usually requiring only confirmation.
- The group is deduced from the current time using the `schedule.csv` file created during installation.
- The solution shown is the first one the group hasn't accessed yet.

> **IMPORTANT**: For automatic selection to work, the tool must distinguish solution repositories from regular ones. This requires following a naming convention:
> - Solution repositories must end with `solution` (customizable).
> - They must appear in the same alphabetical order as assignments are given.
>
> For more details, see [Repository names for solutions](https://github.com/raul-izquierdo/solutions#repository-names-for-solutions).


Suppose the following `schedule.csv` file:
```csv
G1,wednesday 08:00
G2,tuesday 09:00
G-english-1,friday 10:00
```

The output would be:
```bash
$ java -jar solutions.jar
Connecting with Github... done.

[wednesday 08:15] You are currently with group 'G1'. Would you like to show them 'factorial-solution'? (y/N): y
Access granted.
```

When ambiguity exists (no single scheduled group or none pending), the tool falls back to an interactive selection menu.


### Phase 4. At the end of the course

At the end of the course, delete the Teams for your groups to revoke students' access to solution repositories.

```bash
java -jar teams.jar --clean
```

## Access to Resources

### Obtaining the GitHub Token

A GitHub personal access token with the `repo` and `admin:org` scopes is required to manage teams and members. See the [GitHub documentation: Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic) for instructions.

Provide the token in one of three ways (in order of precedence):
1. In a `.env` file (recommended)
2. As a command-line argument: `-t <token>`
3. As an environment variable: `GITHUB_TOKEN`

### Obtaining the Roster File

Each GitHub Classroom has an associated roster—the list of students who can receive assignments.

Some tools in this repository require the roster file. To obtain it:
1. Go to the GitHub Classroom page.
2. Click the "Students" tab.
3. Click the "Download" button to save the CSV file `classroom_roster.csv`.

## License

See `LICENSE`.
Copyright (c) 2025 Raul Izquierdo Castanedo
