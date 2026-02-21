
interface RateLimitConfig {
    interval: number; // in milliseconds
    uniqueTokenPerInterval: number; // Max number of unique tokens per interval
}

const owners = new Map<string, number[]>();

export function rateLimit(config: RateLimitConfig) {
    const { interval, uniqueTokenPerInterval } = config;

    return {
        check: async (limit: number, token: string): Promise<void> => {
            const now = Date.now();
            const windowStart = now - interval;

            const timestamps = owners.get(token) || [];
            const validTimestamps = timestamps.filter((timestamp) => timestamp > windowStart);

            if (validTimestamps.length >= limit) {
                throw new Error('Rate limit exceeded');
            }

            validTimestamps.push(now);
            owners.set(token, validTimestamps);

            // Cleanup
            if (owners.size > uniqueTokenPerInterval) {
                // Simple heuristic to remove old entries if map gets too big
                // In production with multiple instances, use Redis.
                const firstKey = owners.keys().next().value;
                if (firstKey) owners.delete(firstKey);
            }
        },
    };
}
