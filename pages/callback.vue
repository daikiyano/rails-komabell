<template>
    <div>
       <img class="is-centered" src="@/assets/image/loading.png">
    </div>
</template>

<script>
    export default {
      middleware: {
        routing: false
      },
        data() {
            return {
                isFullPage: true,
            }
        },
        
        
    }
</script>



