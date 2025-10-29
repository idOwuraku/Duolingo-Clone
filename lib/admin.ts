import { auth } from "@clerk/nextjs/server";

const adminIds = [
  "user_2gF7aSfrEOmXcQZNLazLFcBKQHs",
];

export const isAdmin = async () => {
  const { userId } = await auth(); // ✅ must await

  if (!userId) {
    return false;
  }

  // give access to only these users
  // return adminIds.includes(userId);

  // give access to everybody
  return true;
};
