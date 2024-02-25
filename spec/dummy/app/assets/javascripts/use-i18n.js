const TestComponent = () => {
  const {t} = useI18n({namespace: "test.component"})

  t(".hello_world")
}

export default TestComponent
