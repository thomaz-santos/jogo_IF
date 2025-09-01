class Camada{
  int lar, alt; //largura e altura em tiles
  PImage tImage; //tileImage
  int tLar, tAlt; //largura e altura de um tile em pixels
  byte[][] layer;
  PImage[] tiles;

  
  public byte get(int linha, int coluna){
    return layer[linha][coluna];    
  }
  
  public Camada(int l, int a, String nomeArquivo, int tLar, int tAlt, PImage tImage, int nTiles){
    lar=l;
    alt=a;
    this.tAlt=tAlt;
    this.tLar=tLar;
    this.tImage=tImage;
    
    byte[] b; 
    b = loadBytes(nomeArquivo);
    layer = new byte[alt][lar];

    for(int i=0;i<b.length;i++){           
        layer[i/lar][i%lar]=b[i];    
    }
    
    tiles = new PImage[nTiles];
    for(int i=0; i<nTiles; i++){
      tiles[i] = tImage.get(i*tLar,0,tLar,tAlt);
    }
  }
  
  public void exibir(float offset){
    for(int i=0; i<alt; i++){
      for(int j=0;j<lar;j++){
        //desenhe o tile referenciado por layer[i][j] na tela
        if(layer[i][j]!=-1) image(tiles[layer[i][j]],j*tLar-cameraX/offset,i*tAlt-cameraY/offset);
      }
    }
  }
  
}
