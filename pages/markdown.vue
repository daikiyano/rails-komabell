<template>
  <div class="mavonEditor">
  
      <mavon-editor :toolbars="markdownOption" :language="'ja'" @change="changeText" v-model="value"/>
   {{mdText}}
  </div>
</template>
<script>
export default {
  data() {
    return {
      markdownOption: {
        bold: true,
        italic: true,
        header: true,
        underline: true,
        strikethrough: true,
        mark: true,
        superscript: true,
        subscript: true,
        quote: true,
        ol: true,
        ul: true,
        link: true,
        imagelink: false,
        code: true,
        table: true,
        fullscreen: true,
        readmodel: true,
        htmlcode: true,
        help: true,     
      },
      value: "#### Markdown",
      mdText: ""

    }
  },
   methods: {
    changeText(value, reder) {
      this.mdText = value;
      
    }
  }
   
};
</script>
 
<style scoped>
.mavonEditor {
  width: 100%;
  height: 100%;
}
</style>