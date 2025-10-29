"use client";

import * as React from "react";
import { Admin, Resource, Layout } from "react-admin";
import simpleRestProvider from "ra-data-simple-rest";

// If you have not upgraded to v5 yet and still use Resources, this is v4 syntax.
// If you ARE using v5+, see note below.

import { CourseList } from "./course/list";
import { CourseCreate } from "./course/create";
import { CourseEdit } from "./course/edit";
import { UnitList } from "./unit/list";
import { UnitCreate } from "./unit/create";
import { UnitEdit } from "./unit/edit";
import { LessonList } from "./lesson/list";
import { LessonCreate } from "./lesson/create";
import { LessonEdit } from "./lesson/edit";
import { ChallengeList } from "./challenge/list";
import { ChallengeCreate } from "./challenge/create";
import { ChallengeEdit } from "./challenge/edit";
import { ChallengeOptionList } from "./challengeOption/list";
import { ChallengeOptionCreate } from "./challengeOption/create";
import { ChallengeOptionEdit } from "./challengeOption/edit";

const dataProvider = simpleRestProvider("/api");

const App = () => (
  <Admin dataProvider={dataProvider}>
    <Resource
      name="courses"
      list={CourseList}
      create={CourseCreate}
      edit={CourseEdit}
    />
    <Resource
      name="units"
      list={UnitList}
      create={UnitCreate}
      edit={UnitEdit}
    />
    <Resource
      name="lessons"
      list={LessonList}
      create={LessonCreate}
      edit={LessonEdit}
    />
    <Resource
      name="challenges"
      list={ChallengeList}
      create={ChallengeCreate}
      edit={ChallengeEdit}
    />
    <Resource
      name="challengeOptions"
      list={ChallengeOptionList}
      create={ChallengeOptionCreate}
      edit={ChallengeOptionEdit}
    />
  </Admin>
);

export default App;
