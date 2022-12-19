<script>
    import { onMount } from 'svelte';
    import axios from "axios";

    let projects = []


    onMount(async () => {
        const resp = await axios.get('http://localhost:8000/metrics/projects');
        console.log('resp', resp.data);
        for (let i=0; i<resp.data.length; i++){
            const snapshotters = await axios.get('http://localhost:8000/metrics/'+resp.data[i]+'/snapshotters');
            console.log(snapshotters.data);
            let proj = {
                id: resp.data[i],
                snapshotters: snapshotters.data.snapshotters
            }
            projects = [...projects, proj];
        }
    });
</script>
<div>
    <h3 class="text-lg font-medium leading-6 text-gray-900">Last 30 days</h3>
    <dl class="mt-5 grid grid-cols-1 gap-5 sm:grid-cols-3">
      <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500">Total Projects</dt>
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900">71,897</dd>
      </div>
  
      <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500">Current Epoch</dt>
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900"></dd>
      </div>
  
      <div class="overflow-hidden rounded-lg bg-white px-4 py-5 shadow sm:p-6">
        <dt class="truncate text-sm font-medium text-gray-500">Epoch Status</dt>
        <dd class="mt-1 text-3xl font-semibold tracking-tight text-gray-900"></dd>
      </div>
    </dl>
</div>
<div class="overflow-hidden bg-white shadow sm:rounded-md">
    <ul role="list" class="divide-y divide-gray-200">
      {#each projects as project}
      <li>
        <a href="#" class="block hover:bg-gray-50">
          <div class="flex items-center px-4 py-4 sm:px-6">
            <div class="min-w-0 flex-1 sm:flex sm:items-center sm:justify-between">
              <div class="truncate">
                <div class="flex text-sm">
                  <p class="truncate font-medium text-indigo-600">{project.id.substr(21, 30)}</p>
                  <p class="ml-1 flex-shrink-0 font-normal text-gray-500">in UniswapV2</p>
                </div>
                <div class="mt-2 flex">
                  <div class="flex items-center text-sm text-gray-500">
                    <!-- Heroicon name: mini/calendar -->
                    <svg class="mr-1.5 h-5 w-5 flex-shrink-0 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                      <path fill-rule="evenodd" d="M5.75 2a.75.75 0 01.75.75V4h7V2.75a.75.75 0 011.5 0V4h.25A2.75 2.75 0 0118 6.75v8.5A2.75 2.75 0 0115.25 18H4.75A2.75 2.75 0 012 15.25v-8.5A2.75 2.75 0 014.75 4H5V2.75A.75.75 0 015.75 2zm-1 5.5c-.69 0-1.25.56-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h10.5c.69 0 1.25-.56 1.25-1.25v-6.5c0-.69-.56-1.25-1.25-1.25H4.75z" clip-rule="evenodd" />
                    </svg>
                    <p>
                      Synced up to
                      <time datetime="2020-01-07">January 7, 2020</time>
                    </p>
                  </div>
                </div>
              </div>
              <div class="mt-4 flex-shrink-0 sm:mt-0 sm:ml-5">
                <div class="flex -space-x-1 overflow-hidden">
                  {#each project.snapshotters as snapshotter}
                  <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" alt="{snapshotter}" src="https://avatars.dicebear.com/api/identicon/{snapshotter}.png">
                  {/each}
                <!--
                  <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" src="https://images.unsplash.com/photo-1517841905240-472988babdf9?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Lindsay Walton">
  
                  <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" src="https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Courtney Henry">
  
                  <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white" src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="Tom Cook">
                -->
                </div>
              </div>
            </div>
            <div class="ml-5 flex-shrink-0">
              <!-- Heroicon name: mini/chevron-right -->
              <svg class="h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z" clip-rule="evenodd" />
              </svg>
            </div>
          </div>
        </a>
      </li>
      {/each}
    </ul>
  </div>