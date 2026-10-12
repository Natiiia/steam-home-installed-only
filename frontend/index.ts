/** @ffi */
export function homeFilterStatus(): string {
  return JSON.stringify((window as any).__homeInstalledOnlySource ?? null);
}
