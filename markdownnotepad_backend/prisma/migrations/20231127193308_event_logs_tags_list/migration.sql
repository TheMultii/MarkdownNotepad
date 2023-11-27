/*
  Warnings:

  - You are about to drop the column `tagId` on the `EventLogs` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "EventLogs" DROP COLUMN "tagId",
ADD COLUMN     "tagsId" TEXT[];
