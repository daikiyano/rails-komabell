<template>
    <div>
        <ValidationProvider vid="email" rules="required|email" :name="$attrs.name || $attrs.label" v-slot="{ errors, valid }">
            <b-field label="メールアドレス"
                :type="{ 'is-danger': errors[0], 'is-success': valid } "
                :message="errors"
            >
                <b-input
                    v-model="innerValue"
                    type="email"
                    placeholder="メールアドレス"
                    maxlength="30"
                >
                </b-input>
            </b-field>
        </ValidationProvider>
    </div>
</template>



<script>
     import { ValidationObserver, ValidationProvider } from 'vee-validate';

    export default {
        name: 'EmailInput',
        components: {
            ValidationObserver,
            ValidationProvider
        },

        data() {
            return {
                innerValue: ""
            }
        },
    watch: {
        innerValue(newVal) {
        this.$emit("input", newVal);
        },
    // Handles external model changes.
    // value(newVal) {
    //   this.innerValue = newVal;
    // }
    },
        methods: {
            
        }
    }
</script>