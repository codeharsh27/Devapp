export const STARTUP_ROLES = [
    "Founder",
    "Co-Founder",
    "CTO",
    "VP of Engineering",
    "Head of Product",
    "Product Manager",
    "Engineering Lead",
];

export function isStartupRole(role: string): boolean {
    return STARTUP_ROLES.includes(role);
}

export function isTalentRole(role: string): boolean {
    return role !== "" && !isStartupRole(role);
}
