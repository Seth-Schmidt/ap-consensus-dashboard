<script>
    import "../app.css";

    import { page } from '$app/stores';
    import { env } from '$env/dynamic/public';

    export let API_PREFIX = env.PUBLIC_API_PREFIX;
    console.log('API_PREFIX', env, API_PREFIX);

    let slug;
    $: {
      //console.log($page);
      slug = $page.route.id.split('/')[1];
      console.log('slug', slug);
    }


</script>

<!--
  This example requires updating your template:

  ```
  <html class="h-full bg-gray-100">
  <body class="h-full">
  ```
-->
<div class="min-h-full">
  <div class="bg-gray-800 pb-32">
    <nav class="bg-gray-800">
      <div class="mx-auto max-w-7xl sm:px-6 lg:px-8">
        <div class="border-b border-gray-700">
          <div class="flex h-16 items-center justify-between px-4 sm:px-0">
            <div class="flex items-center">
              <div class="flex-shrink-0">
                <img class="h-8 w-16" src="/powerloom_logo_dark.png" alt="PowerLoom Logo">
              </div>
              <div class="hidden md:block">
                <div class="ml-10 flex items-baseline space-x-4">
                  <!-- Current: "bg-gray-900 text-white", Default: "text-gray-300 hover:bg-gray-700 hover:text-white" -->
                  <a href="/" class={slug == "" ? "bg-gray-900 text-white px-3 py-2 rounded-md text-sm font-medium" : "text-gray-300 hover:bg-gray-700 hover:text-white px-3 py-2 rounded-md text-sm font-medium"} aria-current="page">Dashboard</a>

                  <a href="/projects" class={slug == "projects" ? "bg-gray-900 text-white px-3 py-2 rounded-md text-sm font-medium" : "text-gray-300 hover:bg-gray-700 hover:text-white px-3 py-2 rounded-md text-sm font-medium"}>Projects</a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </nav>
    <header class="py-10">
      <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
        <h1 class="text-3xl font-bold tracking-tight text-white">{slug == "" ? "Dashboard" : slug}</h1>
      </div>
    </header>
  </div>

  <main class="-mt-32">
    <!-- This example requires Tailwind CSS v2.0+ -->
    <div class="relative z-10" aria-labelledby="modal-title" role="dialog" aria-modal="true">
      <!--
        Background backdrop, show/hide based on modal state.

        Entering: "ease-out duration-300"
          From: "opacity-0"
          To: "opacity-100"
        Leaving: "ease-in duration-200"
          From: "opacity-100"
          To: "opacity-0"
      -->
      <div class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"></div>

      <div class="fixed z-10 inset-0 overflow-y-auto">
        <div class="flex items-end sm:items-center justify-center min-h-full p-4 text-center sm:p-0">
          <!--
            Modal panel, show/hide based on modal state.

            Entering: "ease-out duration-300"
              From: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
              To: "opacity-100 translate-y-0 sm:scale-100"
            Leaving: "ease-in duration-200"
              From: "opacity-100 translate-y-0 sm:scale-100"
              To: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          -->
          <div class="relative bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:max-w-sm sm:w-full sm:p-6">
            <div>
              <div class="mx-auto flex items-center justify-center">
                <img class="h-40" src="/powerloom_white.png" alt="PowerLoom logo">
              </div>
              <div class="text-center">
                <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">Dashboard Deprecated</h3>
                <div class="mt-2">
                  <p class="text-sm text-gray-500">Our offchain consensus is now deprecated as we prepare to launch our first testnet using onchain consensus! <a href="https://powerloom.io/consensus-invite/" class="text-black hover:text-gray-500">Signup here</a> to get early access.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="mx-auto max-w-7xl px-4 pb-12 sm:px-6 lg:px-8">
      <!-- Replace with your content -->
      <div class="rounded-lg bg-white px-5 py-6 shadow sm:px-6">
        <div class="h-96 rounded-lg">
          <slot />
        </div>
      </div>
      <!-- /End replace -->
    </div>
  </main>
</div>

        