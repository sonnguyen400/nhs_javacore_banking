<%--
  Created by IntelliJ IDEA.
  User: Acer Swift 3
  Date: 3/3/2024
  Time: 6:05 PM
  To change this template use File | Settings | File Templates.
--%>
<script>
  function getParent(element,parent_selector){
    let parent=element.parentElement;
    while(!parent.classList.contains(parent_selector)){
      parent=parent.parentElement;
    }
    return parent;
  }
  const formula = {
    email: function (e) {
      return (message = 'Email is invalid') => {
        let result = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(e.value);
        return {
          name: e.name,
          value: result ? e.value : message,
          error: !result,
        };
      };
    },
    exact: function (e) {
      return (reflect, message = 'Invalid value') => {
        let result = e.value === reflect;
        return {
          name: e.name,
          value: result ? e.value : message,
          error: !result,
        };
      };
    },
    required: function (e) {
      return (message = 'This field could not be blank') => {
        let result = e.value.trim() !== '';
        return {
          name: e.name,
          value: result ? e.value : message,
          error: !result,
        };
      };
    },
    min: (e) => {
      return (min, message = `Min value is min`) => {
        let result = e.value >= min;
        return {
          name: e.name,
          value: result ? e.value : message,
          error: !result,
        };
      };
    },
    max:
            (e) =>
                    (max, message = `Max value is max`) => {
                      let result = e.value <= max;
                      return {
                        name: e.name,
                        value: result ? e.value : message,
                        error: !result,
                      };
                    },
    none: function (e) {
      return () => {
        return {
          error: false,
          name: e.name,
          value: e.value,
        };
      };
    },
    agemin:e=>(age,message="age invalid")=>{
      let result=(new Date().getFullYear()-new Date(e.value).getFullYear()) >= Number.parseInt(age);
      return {
        name: e.name,
        value: result ? e.value : message,
        error: !result,
      };
    },minlength: (e) => {
      return (min, message = `Min value is min`) => {
        let result = e.value.length >= min;
        return {
          name: e.name,
          value: result ? e.value : message,
          error: !result,
        };
      };
    },

  };
  function checkRule(element_rule,form){
    let result;
    for(let rule of element_rule.rules){
      if(formula[rule.rule]){
        result=formula[rule.rule](element_rule.element)(rule.value)
        if(result.error) break;
      }else{
        console.warn(`Rule ${rule.rule} is not existed`);
      }
    }
    let errorContainer=element_rule.parent.querySelector(".invalid-feedback");
    if(errorContainer&&result.error){
      errorContainer.style.display="block";
      errorContainer.innerText=result.value;
    }else if(errorContainer){
      errorContainer.style.display="none";
    }
    return !result.error&&{name:result.name,value:result.value};
  }
  function Form(form,onsubmit){
    if($(form).length>=1){
      var elements=$(`${form} .form-control`);
      var element_rules=elements.map((idx,element)=>{
        let rules=element
                .getAttribute("data-rule").split("|")
                .map(data=>{
                  let rule_value=data.split(/[()]/);
                  return {
                    rule:rule_value[0],
                    value:rule_value[1]
                  }
                })
        return {
          element:element,
          rules:rules,
          parent:getParent(element,"form-group")
        }
      }).toArray()
      element_rules.forEach(element_rule=>{
        element_rule.element.addEventListener("blur",e=>{
          checkRule(element_rule,form);
        })
      })
      function formData(){
        return element_rules.reduce((data, element_rule)=>{
          let elementValue=checkRule(element_rule,form);
          if(elementValue===false) {
            console.log(elementValue);
          }
          data.append(elementValue.name,elementValue.value);
          return data;
        },new FormData());
      }
      function isValid(){
        let valid=true;
        for(let element_rule of element_rules){
          if(checkRule(element_rule,form)===false) {
              console.log(element_rule);
            valid=false;
          }
        }
        return valid;
      }
      $(form).on("submit",e=>{
          if(onsubmit){
              if(typeof onsubmit=='function') onsubmit(e,formData());
          }else{
              if(isValid()) return true;
          }
      })
      return {
        formData,
        form:$(form),
        isValid
      }
    }
  }
</script>
