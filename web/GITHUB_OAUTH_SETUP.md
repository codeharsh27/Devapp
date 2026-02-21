# How to Get GitHub Client ID and Secret

To enable GitHub Login, you need to register your application with GitHub.

### Step 1: Create a GitHub OAuth App
1. Log in to your GitHub account.
2. Go to **Settings** (click your profile picture in top right -> Settings).
3. Scroll down to the bottom of the left sidebar and click **Developer settings**.
4. Click **OAuth Apps** on the left.
5. Click the **New OAuth App** button.

### Step 2: Fill in the Application Details
Fill out the form with the following details:

*   **Application Name**: `DevApp (Local)` (or whatever you want users to see)
*   **Homepage URL**: `http://localhost:3000`
*   **Authorization callback URL**: 
    ```
    https://ntrubhipkhaoasqqkozu.supabase.co/auth/v1/callback
    ```
    *(Note: This URL comes from your Supabase project settings. I've used your Project ID from your .env file)*

### Step 3: Get your Credentials
1. Click **Register application**.
2. You will see your **Client ID** (a string of characters). Copy this.
3. Click **Generate a new client secret**.
4. You may need to confirm your password.
5. You will see your **Client Secret**. **Copy this immediately** (you won't be able to see it again).

### Step 4: Add to Supabase
1. Go back to your **Supabase Dashboard**.
2. Go to **Authentication** -> **Providers** -> **GitHub**.
3. Paste the **Client ID**.
4. Paste the **Client Secret**.
5. Click **Save**.

### ⚠️ Important for Production
When you deploy your app to a live domain (e.g., `https://devapp.com`), you will need to:
1. Create a **new** OAuth App in GitHub for production.
2. Set the **Homepage URL** to `https://devapp.com`.
3. Set the **Callback URL** to `https://ntrubhipkhaoasqqkozu.supabase.co/auth/v1/callback` (this stays the same if using the same Supabase project, OR if you have a separate prod Supabase project, use that one's URL).
