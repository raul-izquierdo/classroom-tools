# GitHub Classroom Tools

## Goals

This repository is an index of tools created to assist instructors in managing courses with GitHub Classroom.

Estas herramientas se crearon para dar soporte a la siguiente forma de trabajo:
1. Durante las clases prácticas el profesor muestra en el proyector la solución a cada práctica antes de pasar a la siguiente. Al acabar la explicación sería muy útil que los alumnos tuvieran unos minutos para ver en su ordenador los ficheros de dicha solución a su ritmo y, así, poder asimilar lo explicado y preguntar dudas adicionales al profesor.
    - Sin embargo esto no era práctico, ya que para ello los alumnos tenían que ir a la página web de la asignatura para bajar, descomprimir e importar un proyecto en su IDE, lo cual interrumpía el flujo de la clase práctica y, por tanto, se optó porque lo miraran posteriormente en casa.
2. Una vez que los alumnos subían sus proyectos en formato ZIP, era realmente tedioso para el profesor el descargar, descomprimir e importar cada entrega para revisarla (con los habituales errores de importación).
    - Además, posteriormente, habría que redactar y enviar un informe a cada alumno con las mejoras sugeridas con el suficiente detalle para que el alumno pudiera entenderlas y aplicarlas.

Para evitar estos problemas, esta suite de herramientas permite:
- Que los alumnos puedan ver las soluciones en su ordenador de manera inmediata después de la explicación del profesor, con un click y sin necesidad de instalar nada. Se usará para ello la versión web de VSCode (independientemente del IDE que use el alumno en su ordenador), lo cual permite la navegación propia de un IDE.
- Que el profesor, sin tener que bajar ni instalar nada en su ordenador, pueda revisar las entregas de los alumnos de forma online cambiando de una a otra de forma inmediata.
    - Esta rapidez permite al profesor revisar las entregas durante la misma clase mientras los alumnos trabajan en la siguiente práctica y, por tanto, en vez de tener que redactar un informe, puede pedir al alumno que se acerque y comentarle oralmente las mejoras a realizar, lo cual permite una interacción bidireccional mucho más efectiva.

## Overview of Tools

The tools included in this project are:
- [roster.jar](https://github.com/raul-izquierdo/roster): assists in maintaining the classroom roster as students join, leave, or change lab groups.
- [teams.jar](https://github.com/raul-izquierdo/teams): generates and updates GitHub Teams for each lab group based on the roster, enabling group-based permissions.
- [solutions.jar](https://github.com/raul-izquierdo/solutions): used to show or hide an assignment's solution for a lab group.

These tools are implemented in Java and require JDK 21 or later.

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
   ./get-jars.shv
   ```

3. (Optional) Create a `.env` file with the organization name and the GitHub Classroom API access token.
    ```env
    GITHUB_ORG=<organization associated with the classroom>
    GITHUB_TOKEN=<GitHub token>
    STUDENTS_FILE=<name of the file with the list of students>
    STUDENTS_FORMAT=<format of the previous file>
    ```

    This step is optional. However, providing this file simplifies running the tools, as command-line flags will not be required. This repository includes a `.env.example` file to be copied and edited.

    For information on obtaining the _token_, see [Obtaining the GitHub Token](#obtaining-the-github-token).

    The _STUDENTS_FILE_ should contain a list of students enrolled in your course and their lab groups. How you obtain this list depends on your institution. For example, at the University of Oviedo, this file is provided by the SIES academic management system and the values of those two variables should be:

    ```csv
    STUDENTS_FILE="alumnosMatriculados.xls"
    STUDENTS_FORMAT="sies"
    ```

    See [Student file formats](https://github.com/raul-izquierdo/roster?tab=readme-ov-file#student-file-formats) for more information about other options.

4. Edit the `schedule.csv`, which initially contains just sample data, with the schedules for the teacher groups.
    ```csv
    01, monday, 21:00
    02, tuesday, 14:00, 3h
    i01, wednesday, 16:00, 45m
    ```

## Course Workflow

Although usage and options for each tool are explained in their respective repositories, this index presents the **intended workflow** and **when** to use each tool.
- [Phase 1. At the beginning of the course](#phase-1-at-the-beginning-of-the-course): Create the GitHub Classroom roster (the list of all students), which enables sending assignments.
- [Phase 2. After the first assignment](#phase-2-after-the-first-assignment): Generate GitHub Teams from the roster to grant repository access by group.
- [Phase 3. Managing Changes](#phase-3-managing-changes): Update the roster and Teams when enrollment or lab-group assignments change.
- [Phase 4. At the end of each assignment](#phase-4-at-the-end-of-each-assignment): Grant each group permission to view the assignment solution.
- [Phase 5. At the end of the course](#phase-5-at-the-end-of-the-course): Delete the roster and GitHub Classroom teams, leaving a clean organization for the next course (while keeping starter code and solutions).

> NOTE: In the examples below, it is assumed that the file `.env` has been created with the required variables. If not, these values must be provided on the command line to tools using their respective flags.


### Phase 1. At the beginning of the course

At the beginning of the course, the classroom roster must be created. This roster is the list of students who can receive assignments.

The following steps are required in this phase:

1. **Create a new classroom** (and optionally copy assignments from the previous one) using the GitHub Classroom web interface. No tool is required for this step.

2. Obtain the file with the **list of students** enrolled in the course. That is the file whose name was assigned to the _STUDENTS_FILE_ variable (`alumnosMatriculados.xls` in the example below).

3. **Create the roster** from the student list using `roster.jar`.

    Before creating the roster, if the instructor does not teach all groups, it is useful to specify which groups he teaches to filter his students and ignore the rest. To indicate the instructor’s groups, create a `schedule.csv` file (if not already created in the installation process) and pass it using the `-g` option. The format of this file is explained in [groups file format](https://github.com/raul-izquierdo/roster#groups-file-format). The following examples will use this file.

    Assuming the previous `.env` file, the command to create the roster is:
    ```bash
    java -jar roster.jar create
    ```

    Example output:
    ```bash
    $ java -jar roster.jar create -g schedule.csv -f csv myTextFile

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

    Each generated identifier includes the student’s lab group in parentheses, which facilitates filtering in the Classroom UI.

4. **Enter the roster manually**. GitHub Classroom does not offer an API to automate roster maintenance, so the result from the previous step must be copied and pasted into the web interface. `roster.jar` provides step-by-step instructions for this process.

After completing these steps, when creating repositories for assignment solutions, it is **recommended** to use a naming convention so that the `solutions.jar` tool can automatically deduce the solution corresponding to each class. For more information, see [Repository names for solutions](https://github.com/raul-izquierdo/solutions#repository-names-for-solutions).


### Phase 2. After the first assignment

To allow each group of students to view the solution to their assignment in phase 4, a separate GitHub Team must be created for each group. In this phase these teams will be created. But, unlike the roster, creation of these Teams is automated because GitHub provides an API for this task.

The steps in this phase are as follows:
1. Download an **updated** roster.
2. Create the Teams from the roster.

#### 2.1 Download an Updated roster

The roster was entered manually in phase 1; rather than regenerate it, download it from GitHub Classroom. To obtain this file, follow the instructions in [Obtaining the Roster File](#obtaining-the-roster-file).

**Important:** This step should be performed _after_ students have accepted the first assignment; only then are their roster IDs associated with their GitHub accounts. Note the distinction between:
- The student’s **personal GitHub account/username**: This is the username the student uses to log in to GitHub. The tool `teams.jar` requires it to create the Teams, and it is not included in the roster until the first assignment is accepted.
- The student’s **roster identifier**: This is the identifier generated by `roster.jar` so the instructor can identify students in assignments without knowing their personal GitHub account.

If the roster is downloaded immediately after entry in phase 1, the GitHub username column (2) will be empty.
```csv
"identifier","github_username","github_id","name"
"i01-yaagma (i01)","","",""
"i02-cesar acebal (a02)","","",""
"i02-yaagma (i02)","","",""
```
If the roster is downloaded _after_ students accept the first assignment, each student’s GitHub username will be included, which `teams.jar` requires.
```csv
"identifier","github_username","github_id","name"
"i01-yaagma (i01)","yaagma","40261856",""
"i02-cesar acebal (a02)","cesar24","40394857",""
"i02-yaagma (i02)","perez87","40261856",""
```

In practice, it is not necessary to wait for every student to associate a GitHub account (accept an assignment) to create Teams—some may never do so. It is sufficient to wait until the first assignment is completed and run this phase with the roster as is. Students without associated GitHub accounts will be ignored (and not added to Teams). If the roster is updated later, proceed to [phase 3 (roster and Teams update)](#phase-3-when-a-group-changes).

#### 2.2 Create the Teams

Once a roster that includes each student’s GitHub username is available, use the `teams.jar` tool to create the teams.

```bash
java -jar teams.jar <classroom_roster.csv>
```

The parameter is the roster CSV file. If omitted, the tool defaults to `classroom_roster.csv`.

This command may also be rerun with an updated roster to synchronize Teams: it adds new students, removes withdrawn ones, and moves students who have changed lab groups.

### Phase 3. Managing Changes

During the course—especially in the first weeks—enrollments may change and students may switch lab groups. To keep the roster up to date, just run:
```cmd
update.cmd   # Windows
```
```bash
./update.sh  # Linux/Mac
```

The output will indicate if any changes are needed. If so, follow the instructions to update the roster in GitHub Classroom and the Teams.

### Phase 4. At the end of each assignment

After an assignment has been submitted and the solution has been explained, `solutions.jar` can be used to grant each group permission to access the repository containing the explained solution.

There are two ways to perform this task: manual selection and automatic selection (recommended).

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


> **IMPORTANT**: For automatic selection to work, the tool must be able to distinguish which repositories contain assignment solutions and which are regular repositories. This is achieved by following a naming convention: solution repositories must end with `solution` and, when sorted alphabetically, should appear in the same order as the assignments are given. For more details, see [Repository names for solutions](https://github.com/raul-izquierdo/solutions#repository-names-for-solutions).


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

(now: 'wednesday' 08:15) Proceed to show 'factorial-solution' to group 'G1'? (y/N): y
Access granted.
```

When ambiguity exists (no single scheduled group or none pending), the tool falls back to an interactive picker.

### Phase 5. At the end of the course

At the end of the course, the Teams for the finished course’s groups should be deleted. This revokes students’ access to solution repositories.

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

Each classroom in GitHub Classroom has a roster associated with it. A classroom roster is the list of students that can receive its assignments.

Some of the tools described in this repository require the roster to operate. The steps to obtain this file are:
1. Go to the GitHub Classroom page.
2. Click on the "Students" tab.
3. Click the "Download" button to obtain the CSV file `classroom_roster.csv`.

## License

See `LICENSE`.
Copyright (c) 2025 Raul Izquierdo Castanedo


---
<style>p:has(+ :is(ul,ol)) { margin-bottom: 0; }</style>
