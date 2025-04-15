export function calculateStudyTime(
  start_time: string,
  end_time: string,
) {
  const start = new Date(start_time);
  const end = new Date(end_time);
  const durationMinutes = Math.round((end.getTime() - start.getTime()) / 60000);

  return durationMinutes;
}
