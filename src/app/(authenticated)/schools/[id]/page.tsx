export default async function SchoolViewPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  return (
    <div>
      <h2 className="text-2xl font-bold text-vsba-charcoal">School View</h2>
      <p className="mt-2 text-muted-foreground">School ID: {id}</p>
    </div>
  );
}
