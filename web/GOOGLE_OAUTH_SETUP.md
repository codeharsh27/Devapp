# How to Get Google Client ID and Secret

To enable Google Login, you need to create a project in the Google Cloud Console.

### Step 1: Create a Google Cloud Project
1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Click the project dropdown in the top bar and select **New Project**.
3. Name it `DevApp` and click **Create**.
4. Select the project you just created.

### Step 2: Configure OAuth Consent Screen
1. In the search bar at the top, type "OAuth consent screen" and select it.
2. Select **External** as the User Type and click **Create**.
3. Fill in the required fields:
   - **App name**: `DevApp`
   - **User support email**: Select your email.
   - **Developer contact information**: Enter your email.
4. Click **Save and Continue** through the "Scopes" section (no special scopes needed).
5. Click **Save and Continue** through "Test Users" (you can add yourself if you want to test while in 'Testing' mode, but 'Production' is needed for everyone).
6. Click **Back to Dashboard**.

### Step 3: Create Credentials
1. Click **Credentials** in the left sidebar.
2. Click **Create Credentials** at the top -> **OAuth client ID**.
3. **Application type**: Select **Web application**.
4. **Name**: `DevApp Web Client`.
5. **Authorized JavaScript origins**:
   - Add `http://localhost:3000`
   - (Later, add your production domain, e.g., `https://devapp.com`)
6. **Authorized redirect URIs**:
   - Add `https://ntrubhipkhaoasqqkozu.supabase.co/auth/v1/callback`
   - (This is your Supabase Project URL + `/auth/v1/callback`)
7. Click **Create**.

### Step 4: Get your Credentials
1. A modal will appear with your **Client ID** and **Client Secret**.
2. **Copy these**.

### Step 5: Add to Supabase
1. Go to your **Supabase Dashboard**.
2. Go to **Authentication** -> **Providers** -> **Google**.
3. Paste the **Client ID**.
4. Paste the **Client Secret**.
5. Click **Save**.

### ⚠️ Important Note
Google OAuth can be tricky with "Authorized redirect URIs". Ensure the URL strictly matches what is in Supabase.
