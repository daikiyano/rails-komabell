<template>
<div>

    <h1>My Edit</h1>
        <MyPageTab :activeTab="activeTab" />
   
   <!-- {{user.email}} -->
   <!-- <component :is="MyPageComponent" :user="this.user"></component> -->
   
</div>
</template>
<script>
import MyPageTab from '~/components/users/MyPageTab.vue'

export default {
    components: {
        MyPageTab
    },
    data() {
    return {
      activeTab: 2
    }
    
  },

   methods: {

   }

}

</script>
