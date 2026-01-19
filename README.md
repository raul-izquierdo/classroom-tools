# GitHub Classroom Tools

This repository is an index of tools created to assist instructors in managing programming courses with GitHub Classroom.

These tools are implemented in Java and require JDK 21 or later.

Table of Contents

- [TL;DR. Cheat Sheet](#tldr-cheat-sheet)
- [Motivation for these tools](#motivation-for-these-tools)
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


## TL;DR. Cheat Sheet

You **have already read all the documentation** and installed the tools, and just want to quickly remember when to use them? Here is a quick **summary**:

- At the **beginning** of the course? Create the roster:
    ```bash
    java -jar roster.jar create
    ```
- The students have already accepted the **first assignment**? Now you can **create the teams**:
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

## Motivation for these tools

These tools were developed to support a workflow for lab sessions consisting of:
- In each session, students are given an exercise that they must submit before the next session.
- At the beginning of the following session, the solution is explained and students can ask questions.
- Immediately after the solution is explained, the next exercise is assigned and students work on it during the remainder of the class.

These tools were created with two main objectives in mind:
- Fast **review** of student submissions by the instructor. This objective is achieved with a single tool:
    - [roster.jar](https://github.com/raul-izquierdo/roster).
- Fast **delivery of solutions** to students during lab sessions. This objective is achieved with two tools:
    - [teams.jar](https://github.com/raul-izquierdo/teams).
    - [solutions.jar](https://github.com/raul-izquierdo/solutions).

Depending on the instructor's needs, they may choose to add only the first feature to their workflow (and therefore only need to use `roster.jar`), or incorporate both features (and use all three programs). In other words, the first feature is **independent** of the second (but the second depends on the first).

If you are only interested in the first feature, you only need to read the documentation of [roster.jar](https://github.com/raul-izquierdo/roster) and can ignore this repository, which is dedicated to the usage of **both features** together.

As an additional tool, [merge-gits.jar](https://github.com/raul-izquierdo/merge-gits) is useful for merging the initial code of an assignment and its solution, but its usage is independent of the other tools and is not detailed in this index. It is recommended to consult its [usage scenario](https://github.com/raul-izquierdo/merge-gits) on Github.

### Feature 1: Fast Review of Student Submissions

Before these tools were implemented, reviewing student submissions was a slow and cumbersome process:
- Students submitted their projects as ZIP files. It was extremely time-consuming for the instructor to **download, extract, and import** each submission for review (often encountering import errors).
- Additionally, the instructor then had to write and send a **detailed report** to each student outlining the errors found, with enough detail for the student to understand and avoid repeating them.

GitHub Classroom allows the instructor to review student submissions online, switching between them **instantly** without downloading or installing anything locally.
- This speed allows the instructor to review submissions during the same class while students work on the next exercise. Instead of writing a report, the instructor can even ask the student to come over and discuss improvements in person, enabling much more **effective two-way interaction**.

But the drawback of GitHub Classroom is that creating the roster and, above all, keeping it up to date with students' changes is a challenge. The tool that addresses this issue is [roster.jar](https://github.com/raul-izquierdo/roster), which assists in maintaining the classroom roster as students join, leave, or change lab groups.

### Feature 2: Fast Delivery of Solutions to Students

During lab sessions, after the explanation of the solution on the projector (and **not before**), it would be very helpful for students to have a few minutes to review the solution files on their own computers, at their own pace, so they can better understand the material, compare with their own work, and ask additional questions.

However, in practice, this was not feasible because the process was **too slow**. Students had to visit the course website, download, extract, and import a project into their IDE, which disrupted the flow of the lab session. As a result, students were asked to review the solutions at home instead.

To address these issues, this suite of tools enables students to **immediately** view solutions on their own computers after the instructor's explanation, with a single click and no need to install anything. This is achieved with two tools:
- [teams.jar](https://github.com/raul-izquierdo/teams): creates and updates GitHub Teams for each lab group, enabling group-based permissions.
- [solutions.jar](https://github.com/raul-izquierdo/solutions): used to show or hide an assignment's solution for a lab group.

## Installation

To use these tools, download each tool’s JAR from its repository. Although manual download is possible, this repository includes download scripts (`get-jars.sh` or `get-jars.cmd`) that automate the process. Therefore, the recommended installation steps are:

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

    This step is optional. However, providing this file simplifies running the tools, as command-line flags will not be required. This repository includes a `.env.example` file to be copied and edited.

    About how to obtain the values for the above variables:
    - The required organization in _GITHUB_ORG_ is the one that **contains the solution repositories**. Depending on your preferences, this may differ from the organization linked to GitHub Classroom. Some instructors prefer to store solutions in a separate organization from the one used for assignments (which is my recommendation). In this case, be sure to specify the organization containing the solutions here.
    - For information on obtaining the _token_, see [Obtaining the GitHub Token](#obtaining-the-github-token).
    - The _STUDENTS_FILE_ should contain a list of students enrolled in your course and their lab groups. How you obtain this list depends on your institution. For example, at the University of Oviedo, this file is provided by the SIES academic management system and the values of those two variables should be:
        ```csv
        STUDENTS_FILE="alumnosMatriculados.xls"
        STUDENTS_FORMAT="sies"
        ```
        See [Student file formats](https://github.com/raul-izquierdo/roster?tab=readme-ov-file#student-file-formats) for more information about other options.

4. Edit the `schedule.csv`, which initially contains just sample data, with the schedules for your assigned groups. If no duration is specified, a default of 2 hours (2h) is assumed. Example:
    ```csv
    01, monday, 21:00
    02, tuesday, 14:00, 3h
    i01, wednesday, 16:00, 45m
    ```

## Course Workflow

Although the detailed usage and options for each tool are explained in their respective repositories, this index presents the **intended workflow** and **when** to use each tool.
- [Phase 1. At the beginning of the course](#phase-1-at-the-beginning-of-the-course) create the GitHub Classroom roster, which enables sending assignments.
- [Phase 2. Managing Changes](#phase-2-managing-changes). Update the roster and Teams when enrolment or lab-group assignments change.
- [Phase 3. At the end of each assignment](#phase-3-at-the-end-of-each-assignment) grant each group permission to view the assignment solution.
- [Phase 4. At the end of the course](#phase-4-at-the-end-of-the-course) delete the roster and GitHub Classroom teams, leaving a clean organization for the next course (while keeping starter code and solutions).

> NOTE: In the examples below, it is assumed that the file `.env` has been created with the required variables. If not, these values must be provided on the command line to tools using their respective flags.


### Phase 1. At the beginning of the course

At the beginning of the course, the classroom roster must be created. This roster is the list of students who can receive assignments.

The following steps are required in this phase:

1. Obtain the file with the **list of students** enrolled in the course. That is the file whose name was assigned to the _STUDENTS_FILE_ variable (`alumnosMatriculados.xls` in the example below).

2. **Create the roster** from the student list using `roster.jar`.

    Before creating the roster, if the instructor does not teach all groups, it is useful to specify which groups he teaches to filter his students and ignore the rest. To indicate the instructor’s groups, create a `schedule.csv` file (if not already created in the installation process) and pass it using the `-s` option. The format of this file is explained in [groups file format](https://github.com/raul-izquierdo/roster#groups-file-format). The following examples will use this file.

    Assuming the previous `.env` file, the command to create the roster is:
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

3. **Enter the roster manually**. GitHub Classroom does not offer an API to automate roster maintenance, so the result from the previous step must be copied and pasted into the web interface. `roster.jar` provides step-by-step instructions for this process.


### Phase 2. Managing Changes

This phase must be repeated when:
- There are **changes in enrollment** or lab-group assignments (changes in `alumnoMatriculados.xls` or equivalent file)
- After a student accepts the **first assignment** of the course.

**IMPORTANT**: Don't forget to run this phase for each group **between** their _acceptance_ of the first assignment and the _explanation_ of its solution. GitHub Classroom does not link the student's personal GitHub account with the roster until they accept their first assignment, and this account is needed to create the teams used to manage access to the solutions.

To manage either of these two changes, the following step is required:
```cmd
update.cmd   # Windows
```
```bash
./update.sh  # Linux/Mac
```

The output will indicate if any changes are needed. If so, follow the instructions provided in the output to update the roster in GitHub Classroom and update the Teams.


### Phase 3. At the end of each assignment

After an assignment has been submitted and the solution has been explained, `solutions.jar` can be used to grant each group permission to access the repository containing the explained solution.

There are two ways to perform this task: _manual_ selection and _automatic_ selection (recommended).

#### Manual selection

To perform manual selection of the group and the solution, execute the following command:
```bash
java -jar solutions.jar
```

This command presents a menu for selecting the group and the solution to show or hide. Once this is done, students will have access to the specified repository.

#### Automatic selection

This is the recommended option, as the tool deduces the group and the solution to show, and in most cases, confirmation will be sufficient.
- The group is deduced from the current time, using the `schedule.csv` file created during installation.
- The solution to show is the first one for which the group does not yet have access.

> **IMPORTANT**: For automatic selection to work, the tool must be able to distinguish which repositories contain assignment solutions and which are regular repositories. This is achieved by following a naming convention:
> - Solution repositories must end with `solution` (although this can be changed).
> - In addition, when sorted alphabetically, should appear in the same order as the assignments are given.
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

At the end of the course, the Teams for the finished course’s groups should be deleted. This revokes students’ access to the solution repositories.

```bash
java -jar teams.jar --clean
```

## Access to Resources

### Obtaining the GitHub Token

A GitHub personal access token with the `repo` and `admin:org` scopes is required to manage teams and members. For instructions on how to create a token, see the [GitHub documentation: Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic).

Once the token is available, it can be provided in three ways (in order of precedence):
1. In a `.env` file (recommended)
2. As a command-line argument: `-t <token>`
3. As an environment variable: `GITHUB_TOKEN`

### Obtaining the Roster File

Each classroom in GitHub Classroom has a roster associated with it. A classroom roster is the list of students who can receive its assignments.

Some of the tools described in this repository require the roster file to operate. To obtain this file:
1. Go to the GitHub Classroom page.
2. Click on the "Students" tab.
3. Click the "Download" button to obtain the CSV file `classroom_roster.csv`.

## License

See `LICENSE`.
Copyright (c) 2025 Raul Izquierdo Castanedo


---
<style>p:has(+ :is(ul,ol)) { margin-bottom: 0; }</style>
