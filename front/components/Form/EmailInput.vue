<template>
    <div>
        <ValidationProvider vid="email" rules="required|email" :name="$attrs.name || $attrs.label" v-slot="{ errors, valid }">
            <b-field 
                v-bind="$attrs"
                :type="{ 'is-danger': errors[0], 'is-success': valid } "
                :message="errors"
            >
                <b-input
                    v-bind="$attrs"
                    type="email"
                    icon="email"
                    placeholder="メールアドレス"
                    maxlength="30"
                    @input="innerValue"
                   :value="value"
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
        props: {
            'value': {
            type: String
            }
        },

        methods: {
            innerValue(newVal) {
            console.log(newVal)
        this.$emit("input", newVal);
        }
            
        }
    }
</script>
