# GitHub Classroom Tools

This repository is an index of tools created to help instructors manage courses in GitHub Classroom.

The tools that are part of this project are:
- [roster.jar](https://github.com/raul-izquierdo/roster): helps maintain the classroom roster as students join, leave, or change lab groups.
- [teams.jar](https://github.com/raul-izquierdo/teams): based on the roster, generates and updates GitHub Teams for each lab group, enabling group-based permissions.
- [solutions.jar](https://github.com/raul-izquierdo/solutions): used to show or hide an assignment's solution for a lab group.

These tools are implemented in Java and require JDK 21 or later.

## Installation

To use these tools, download each tool’s JAR from its repository. Although you can do this manually, this repository includes installation scripts (`install.sh` or `install.cmd`) that automate the downloads. The recommended installation steps are:

1. Clone this repository:
   ```bash
   git clone https://github.com/raul-izquierdo/classroom-tools.git
   cd classroom-tools
   ```

2. Run the installation script for your OS to download the tools' JARs.
   ```bash
   # Windows
   install.cmd

   # Linux/Mac
   ./install.sh
   ```

3. (optional) Fill in the `.env` file with the organization name and the GitHub Classroom API access token. A template for this file is included when you clone the repo.
    ```env
    GITHUB_ORG=<organization>
    GITHUB_TOKEN=<token>
    ```
    This step is optional—so you may delete the `.env` file. However, it significantly simplifies running the tools since you won’t need to pass flags on the command line. For how to obtain the token, see [Obtaining the GitHub Token](#obtaining-the-github-token).

4. (optional) Create the `schedule.csv` file with the schedules for your groups. A template is included in the repo; it contains sample groups you should replace with your real groups.
    ```csv
    01, monday, 21:00
    02, tuesday, 14:00, 3h
    i01, wednesday, 16:00, 45m
    ```
    This file is only necessary if you are going to use the automatic selection of solutions (see [Phase 4](#phase-4-at-the-end-of-each-assignment)), which is highly recommended (in fact, it's the origin of this project).
    For more information on how to create this file, read the section [schedule file format](https://github.com/raul-izquierdo/solutions/#schedule-file-format).


## Course workflow

Although usage and options for each tool are explained in their own repositories, this index shows the intended workflow and when to use each tool.
- [Phase 1. At the beginning of the course](#phase-1-at-the-beginning-of-the-course). Create the GitHub Classroom roster (the list of all students), which enables sending assignments.
- [Phase 2. After the first assignment](#phase-2-after-the-first-assignment). Generate GitHub Teams from the roster to grant repository access by group.
- [Phase 3. When a group changes](#phase-3-when-a-group-changes). Update the roster and Teams when enrollment or lab-group assignments change.
- [Phase 4. At the end of each assignment](#phase-4-at-the-end-of-each-assignment). Grant each group permission to view the assignment solution.
- [Phase 5. At the end of the course](#phase-5-at-the-end-of-the-course). Delete the roster and GitHub Classroom teams, leaving a clean organization for the next course (while keeping starter code and solutions).

> NOTE: In the examples below, it’s assumed the organization and GitHub token are defined in the `.env` file. If not, pass them on the command line to tools that require them using the `-o` and `-t` flags, respectively.


### Phase 1. At the beginning of the course

Do the following in this phase:
1. **Create a new classroom** (and optionally copy assignments from the previous one). Use the GitHub Classroom web interface—no tool is needed in this step.
2. [Get the list of students](#11-get-the-list-of-students) enrolled in the course.
3. [Generate the roster](#12-generate-the-roster) in GitHub Classroom from it.
4. [Enter the roster](#13-enter-the-roster) manually in GitHub Classroom.

> NOTE. When creating the repositories with the solutions to the assignments, it is recommended to use a naming convention so that the `solutions.jar` tool can automatically deduce the solution that corresponds to each class. For more information, read the section [Repository names for solutions](https://github.com/raul-izquierdo/solutions#repository-names-for-solutions).

#### 1.1 Get the list of students

In this step, locate a list of the students enrolled in the course and their lab groups. How you obtain it depends on your institution. At the University of Oviedo, this file is provided by the SIES academic management system. If that’s not available, you can use an Excel sheet or a simple TXT/CSV file like the following:

```csv
"Izquierdo Castanedo, Raúl", grupo01
"González, Juan", grupo_ingles_02
"Alonso, Mariano", grupo01
"Rodríguez, Javier", grupo02
```
On the [roster.jar tool page](https://github.com/raul-izquierdo/roster#students-file-formats) you can see the options available to provide the students list.

#### 1.2 Generate the roster

Once you have the student and lab‑group data, use `roster.jar` to create the roster.

Usage examples:
```bash
# Create a roster from SIES
java -jar roster.jar create alumnosMatriculados.xls -f sies
```

```bash
# Create a roster from a simple excel file with two columns
java -jar roster.jar create myExcelFile.xls -f excel
```

```bash
# Create a roster from a simple txt file
java -jar roster.jar create myTextFile.txt -f csv
```

Example output:
```bash
$ java -jar roster.jar create myTextFile -f csv

## Students to add to the roster

Instructions:
- Go to the Classroom page.
- Click the 'Students' tab.
- Click the 'Update Students' button.
- Select and copy all the lines below at once, then paste them into the 'Create your roster manually' text area.

Izquierdo Castanedo, Raúl (grupo01)
González Pérez, Juan (grupo_ingles_02)
Alonso, Mariano (grupo01)
Rodríguez, Javier (grupo02)
```

Each generated identifier includes the student’s lab group in parentheses, which makes it easier to filter in the Classroom UI.

##### Filtering the teacher's groups

Usually, not all course groups belong to you. To filter and generate only your students, you have two options:
- Manually remove from the input file all students in other instructors’ groups. You’d have to repeat this every time you update it, so this is not recommended.
- Leave the students file as is and, with the `-g` option, list the groups that belong to you. The format of this file is explained in [Groups file format](https://github.com/raul-izquierdo/roster#groups-file-format). If you created it during installation, you can use `schedule.csv` directly.

    If you choose this option, run:
    ```bash
    java -jar roster.jar create alumnosMatriculados.xls -f sies -g schedule.csv
    ```

    With this invocation, only students in groups listed in `schedule.csv` will appear in the output.

#### 1.3 Enter the roster

GitHub Classroom does not offer an API to automate roster maintenance, so you must copy and paste the previous command’s result into the GitHub Classroom web interface. The program prints step‑by‑step instructions, as shown above.

### Phase 2. After the first assignment

To be able to show the solution of each assignment independently to each group of students in phase 4, a GitHub Team must now be created for each one. The creation of these Teams, unlike the roster, is automated because GitHub offers an API for it.

The steps in this phase are as follows:
1. Get the roster.
2. Create the Teams from the roster.

#### 2.1 Get the roster file

The roster was entered manually in phase 1; rather than regenerate it, download it from GitHub Classroom. To obtain this file, follow the instructions in [Obtaining the Roster File](#obtaining-the-roster-file).

Important: run this after students accept the first assignment; that’s when their roster IDs are associated with their GitHub accounts.

Don’t confuse:
- The student’s roster identifier (generated by `roster.jar` so the instructor can identify students in assignments without knowing their GitHub accounts), with
- The student’s personal GitHub account (needed to create Teams and not included in the roster until they accept the first assignment).

If you download the roster immediately after entering it in phase 1, the GitHub username column (2) will be empty.
```csv
"identifier","github_username","github_id","name"
"i01-yaagma (i01)","","",""
"i02-cesar acebal (a02)","","",""
"i02-yaagma (i02)","","",""
```
If you download the roster after students accept the first assignment, you’ll get each student’s GitHub username, which `teams.jar` needs.
```csv
"identifier","github_username","github_id","name"
"i01-yaagma (i01)","yaagma","40261856",""
"i02-cesar acebal (a02)","cesar24","40394857",""
"i02-yaagma (i02)","perez87","40261856",""
```

> NOTE: You don’t need to wait for every student to associate a GitHub account (accept an assignment) to create Teams—some may never do it. It’s enough to wait until the first assignment finishes and run this phase with the roster as‑is. Students without associated GitHub accounts will be ignored (and not added to Teams). Later, if the roster updates, proceed to [phase 3 (roster and Teams update)](#phase-3-when-a-group-changes).

#### 2.2 Create the Teams

Once you have a roster that includes each student’s GitHub username, use the `teams.jar` tool to create the teams.

```bash
java -jar teams.jar <classroom_roster.csv>
```

The parameter is the roster CSV file. If omitted, the tool defaults to `classroom_roster.csv`.

You can also rerun this command with an updated roster to sync Teams: it adds new students, removes withdrawn ones, and moves students who changed lab groups.

### Phase 3. When a group changes

During the course—especially in the first weeks—enrollments change and students often switch lab groups. To keep the roster up to date, do the following:

1. Obtain an updated list of students and their lab groups. Again, using SIES or the teacher's own information system.
2. [Download the roster](#obtaining-the-roster-file).
3. [Determine the changes to make](#31-determine-the-changes-to-make) in the roster by comparing the two files from steps 1 and 2 using `roster.jar`.
4. Manually enter the changes obtained in step 3 following the instructions shown in the output of the `roster.jar` command.
5. To update the Teams, [download the updated roster](#obtaining-the-roster-file) again. Important: the copy from step 2 is no longer valid because you’ve manually edited the roster in step 4—download a fresh copy.
6. Update the Teams with the same command with which they were created. This command will automatically detect the changes and will know that it is an update instead of a creation.
    ```bash
    java -jar teams.jar <classroom_roster.csv>
    ```

#### 3.1 Determine the changes to make

For step 3, use `roster.jar` again, this time with the `update` command:
```bash
java -jar roster.jar update alumnosMatriculados.xls -f sies -r classroom_roster.csv -g schedule.csv
```

The output, unlike `create`, includes up to three sections (only those with changes will appear):
- **Students to add to the roster** — newly enrolled students
- **Students to remove from the roster** — students who have dropped out
- **Students who have changed groups** — students who changed lab group

Example output:
```bash
$ java -jar roster.jar update alumnosMatriculados.xls -f sies -r classroom_roster.csv -g schedule.csv

## Students to add to the roster

Instructions:
- Go to the Classroom page.
- Click the 'Students' tab.
- Click the 'Update Students' button.
- Select and copy all the lines below at once, then paste them into the 'Create your roster manually' text area.

Izquierdo Castanedo, Raúl (01)
González Pérez, Juan (i02)

## Students to remove from the roster

Instructions:
- Go to the Classroom page.
- Click the 'Students' tab.
- For each of the following lines:
	- Find the student with that roster ID and click the "trash" icon.

Rodríguez Pérez, Mariano (01)
Gómez Alonso, Antonio (i01)

## Students who have changed groups

Instructions:
- Go to the Classroom page.
- Click the 'Students' tab.
- For each of the following lines:
	- Find the student using the old roster ID (shown on the left side of the arrow) and click the "pen" icon.
	- Replace the old roster ID with the new one (shown on the right side of the arrow).

González Pérez, Juan (02) ---> González Pérez, Juan (03)
Valles Fuertes, Pedro (i01) ---> Valles Fuertes, Pedro (i02)
Ramírez Barragán, Lucía (01) ---> Ramírez Barragán, Lucía (02)
```

As you can see, the output includes step‑by‑step instructions for performing each change (additions, removals, and moves).

### Phase 4. At the end of each assignment

After an assignment has been submitted and the teacher has explained the solution, with `solutions.jar` you can grant each group permission to access the repository with the explained solution.

<!-- TODO: 📅 /**/ Link to where the team and repository name formats are explained in solutions.jar -->

There are two ways to do it: manual selection and automatic selection (recommended).


#### Manual selection

To perform manual selection of the group and the solution, run the following command:
```bash
java -jar solutions.jar
```

This command will present a menu for the teacher to select the group and the solution they want to show/hide. Once this is done, the students will have access to that repository.

#### Automatic selection

This is the recommended option, as the tool deduces the group and the solution to show and, most of the time, it will be enough to confirm the proposal.
- The group is deduced from the current time. For this, the `schedule.csv` file created during installation is used.
- The solution to show is the first one for which the group does not yet have access. For this, the names of the solution repositories, when sorted alphabetically, must correspond to the order of the classes.


Suppose this `schedule.csv` file:
```csv
G1,wednesday 08:00
G2,tuesday 09:00
G-english-1,friday 10:00
```

In this case, the tool would be invoked by passing that file:
```bash
java -jar solutions.jar -s schedule.csv
```
The output would be:
```bash
$ java -jar solutions.jar -s schedule.csv
Connecting with Github... done.

(now: 'wednesday' 08:15) Proceed to show 'factorial-solution' to group 'G1'? (y/N): y
Access granted.
```

When ambiguity exists (no single scheduled group or none pending), it falls back to an interactive picker.

### Phase 5. At the end of the course

At the end of the course, delete the Teams for the finished course’s groups:

```bash
java -jar teams.jar --clean
```

This revokes students’ access to solution repositories.


## Access to resources

### Obtaining the GitHub Token

You need a GitHub personal access token with the `repo` and `admin:org` scopes to manage teams and members. For instructions on how to create a token, see the [GitHub documentation: Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens#creating-a-personal-access-token-classic).

Once you have the token, you can provide it in three ways (in order of precedence):
1. In a `.env` file (recommended)
2. As a command-line argument: `-t <token>`
3. As an environment variable: `GITHUB_TOKEN`

### Obtaining the Roster File

The roster is the list of students that can receive assignments. Some of the tools described in this repository require this file to operate. The roster can be downloaded from the organization page.

The steps to get this file are:
1. Go to your GitHub Classroom page.
2. Click on the "Students" tab.
3. Click the "Download" button to get the CSV file `classroom_roster.csv`.


## License

See `LICENSE`.
Copyright (c) 2025 Raul Izquierdo Castanedo
