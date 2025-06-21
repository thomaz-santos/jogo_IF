class Timer{
  private long tempoAtual;
  private long ultimoTempo;
  private int intervalo;
  
  public Timer(int intervalo){
    this.intervalo=intervalo;
    ultimoTempo= millis();
  }
  
  public boolean disparou(){
    tempoAtual=millis();
    if(tempoAtual-ultimoTempo>intervalo){
      ultimoTempo=ultimoTempo+intervalo;
      return true;
    }
    return false;
  }      
}
