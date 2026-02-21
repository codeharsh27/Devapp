export const STARTUP_ROLES = [
    'Founder',
    'Co-Founder',
    'CTO',
    'VP of Engineering',
    'Head of Product',
    'Product Manager',
    'Engineering Lead'
] as const;

export const TALENT_ROLES = [
    'Developer',
    'Designer',
    'Product Designer',
    'Mobile Developer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'DevOps Engineer'
] as const;

export type StartupRole = typeof STARTUP_ROLES[number];
export type TalentRole = typeof TALENT_ROLES[number];

export const isStartupRole = (role: string): boolean => {
    return STARTUP_ROLES.includes(role as StartupRole);
};

export const isTalentRole = (role: string): boolean => {
    return TALENT_ROLES.includes(role as TalentRole);
};

export const ALL_ROLES = [...STARTUP_ROLES, ...TALENT_ROLES];
