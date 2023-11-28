-- AlterTable
ALTER TABLE "EventLogs" ADD COLUMN     "catalogTitle" TEXT,
ADD COLUMN     "noteTitle" TEXT,
ADD COLUMN     "tagsTitles" TEXT[] DEFAULT ARRAY[]::TEXT[],
ALTER COLUMN "tagsId" SET DEFAULT ARRAY[]::TEXT[];
